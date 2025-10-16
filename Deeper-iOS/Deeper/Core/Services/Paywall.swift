import Foundation
import StoreKit

/// StoreKit 2 manager for handling in-app purchases
@MainActor
final class PaywallService: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let productIDs = [
        "com.davidmoreno.deeper.yearly",
        "com.davidmoreno.deeper.monthly"
    ]
    
    init() {
        // Initialize StoreKit 2
        Task {
            await loadProducts()
        }
    }
    
    // MARK: - Product Loading
    
    /// Load available products from App Store
    func loadProducts() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let storeProducts = try await Product.products(for: productIDs)
            
            await MainActor.run {
                self.products = storeProducts
                self.isLoading = false
            }
            
            print("✅ Loaded \(storeProducts.count) products from App Store")
            
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to load products: \(error.localizedDescription)"
                self.isLoading = false
            }
            
            print("❌ Failed to load products: \(error)")
        }
    }
    
    // MARK: - Purchase Handling
    
    /// Purchase a product
    func purchase(_ product: Product) async -> PurchaseResult {
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                
                // Handle successful purchase
                await handleSuccessfulPurchase(transaction)
                
                // Finish the transaction
                await transaction.finish()
                
                return .success(transaction)
                
            case .userCancelled:
                return .userCancelled
                
            case .pending:
                return .pending
                
            @unknown default:
                return .failed("Unknown purchase result")
            }
            
        } catch {
            print("❌ Purchase failed: \(error)")
            return .failed(error.localizedDescription)
        }
    }
    
    /// Purchase yearly subscription
    func purchaseYearly() async -> PurchaseResult {
        guard let yearlyProduct = products.first(where: { $0.id == "com.davidmoreno.deeper.yearly" }) else {
            return .failed("Yearly product not available")
        }
        
        return await purchase(yearlyProduct)
    }
    
    /// Purchase monthly subscription
    func purchaseMonthly() async -> PurchaseResult {
        guard let monthlyProduct = products.first(where: { $0.id == "com.davidmoreno.deeper.monthly" }) else {
            return .failed("Monthly product not available")
        }
        
        return await purchase(monthlyProduct)
    }
    
    // MARK: - Restore Purchases
    
    /// Restore previous purchases
    func restorePurchases() async -> Bool {
        do {
            try await AppStore.sync()
            
            // Check for active subscriptions
            for await result in Transaction.currentEntitlements {
                let transaction = try checkVerified(result)
                
                if transaction.productType == .autoRenewable {
                    await handleSuccessfulPurchase(transaction)
                }
            }
            
            print("✅ Purchases restored successfully")
            return true
            
        } catch {
            print("❌ Failed to restore purchases: \(error)")
            return false
        }
    }
    
    // MARK: - Subscription Status
    
    /// Check if user has active subscription
    func hasActiveSubscription() async -> Bool {
        for await result in Transaction.currentEntitlements {
            let transaction = try? checkVerified(result)
            
            if transaction?.productType == .autoRenewable {
                return true
            }
        }
        
        return false
    }
    
    /// Get current subscription status
    func getSubscriptionStatus() async -> SubscriptionStatus {
        for await result in Transaction.currentEntitlements {
            let transaction = try? checkVerified(result)
            
            if let transaction = transaction, transaction.productType == .autoRenewable {
                return .active(transaction)
            }
        }
        
        return .none
    }
    
    // MARK: - Helper Methods
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw PaywallError.unverifiedTransaction
        case .verified(let safe):
            return safe
        }
    }
    
    private func handleSuccessfulPurchase(_ transaction: Transaction) async {
        print("✅ Successful purchase: \(transaction.productID)")
        
        // Update user's subscription status
        // In a real app, this would update the user's account status
        // and potentially sync with your backend
        
        // For now, just log the purchase
        print("📱 User purchased: \(transaction.productID)")
        print("📅 Purchase date: \(transaction.purchaseDate)")
        
        if let expirationDate = transaction.expirationDate {
            print("⏰ Expires: \(expirationDate)")
        }
    }
    
    // MARK: - Product Information
    
    /// Get product by ID
    func getProduct(id: String) -> Product? {
        return products.first { $0.id == id }
    }
    
    /// Get yearly product
    func getYearlyProduct() -> Product? {
        return getProduct(id: "com.davidmoreno.deeper.yearly")
    }
    
    /// Get monthly product
    func getMonthlyProduct() -> Product? {
        return getProduct(id: "com.davidmoreno.deeper.monthly")
    }
    
    /// Format price for display
    func formatPrice(for product: Product) -> String {
        return product.displayPrice
    }
}

// MARK: - Purchase Result

enum PurchaseResult {
    case success(Transaction)
    case userCancelled
    case pending
    case failed(String)
}

// MARK: - Subscription Status

enum SubscriptionStatus {
    case none
    case active(Transaction)
    case expired(Transaction)
}

// MARK: - Paywall Errors

enum PaywallError: Error, LocalizedError {
    case unverifiedTransaction
    case productNotAvailable
    case purchaseFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .unverifiedTransaction:
            return "Transaction could not be verified"
        case .productNotAvailable:
            return "Product is not available for purchase"
        case .purchaseFailed(let message):
            return "Purchase failed: \(message)"
        }
    }
}

// MARK: - Product Extensions

extension Product {
    /// Check if this is a yearly subscription
    var isYearly: Bool {
        return id == "com.davidmoreno.deeper.yearly"
    }
    
    /// Check if this is a monthly subscription
    var isMonthly: Bool {
        return id == "com.davidmoreno.deeper.monthly"
    }
    
    /// Get subscription period description
    var subscriptionPeriodDescription: String {
        if isYearly {
            return "per year"
        } else if isMonthly {
            return "per month"
        } else {
            return "subscription"
        }
    }
}
