import XCTest
@testable import Deeper

/// Unit tests for OnboardingStore persistence and Step 17 navigation
final class OnboardingStorePersistenceTests: XCTestCase {
    
    private var onboardingStore: OnboardingStore!
    private var testDirectory: URL!
    
    override func setUp() {
        super.setUp()
        
        // Create a temporary directory for testing
        testDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent("DeeperTests")
            .appendingPathComponent(UUID().uuidString)
        
        try? FileManager.default.createDirectory(
            at: testDirectory,
            withIntermediateDirectories: true
        )
        
        // Initialize store with test directory
        onboardingStore = OnboardingStore()
    }
    
    override func tearDown() {
        // Clean up test directory
        try? FileManager.default.removeItem(at: testDirectory)
        onboardingStore = nil
        super.tearDown()
    }
    
    // MARK: - Step Index Persistence Tests
    
    func testStepIndexPersistence() async {
        // Given
        let initialStepIndex = 0
        XCTAssertEqual(onboardingStore.stepIndex, initialStepIndex)
        
        // When - Navigate to Step 17 (index 16)
        onboardingStore.setStepIndex(16)
        
        // Then
        XCTAssertEqual(onboardingStore.stepIndex, 16)
        
        // Simulate app relaunch by creating a new store instance
        let newStore = OnboardingStore()
        
        // Wait for hydration
        let expectation = XCTestExpectation(description: "Store hydration")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1.0)
        
        // Verify step index persisted
        XCTAssertEqual(newStore.stepIndex, 16)
    }
    
    func testNavigateToStep17AndPersist() async {
        // Given
        XCTAssertEqual(onboardingStore.stepIndex, 0)
        
        // When - Navigate through steps to reach Step 17
        for i in 1...16 {
            onboardingStore.setStepIndex(i)
        }
        
        // Then
        XCTAssertEqual(onboardingStore.stepIndex, 16) // Step 17 is index 16
        
        // Verify we can access Step 17 data
        let flow = FlowManifest.flow
        let step17 = flow[16]
        XCTAssertEqual(step17.id, "currentRating")
        XCTAssertEqual(step17.kind, .rating)
        
        // Simulate app relaunch
        let newStore = OnboardingStore()
        
        // Wait for hydration
        let expectation = XCTestExpectation(description: "Store hydration")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1.0)
        
        // Verify we're still at Step 17
        XCTAssertEqual(newStore.stepIndex, 16)
    }
    
    func testStep17RatingPayload() {
        // Given
        let flow = FlowManifest.flow
        let step17 = flow[16]
        
        // When
        let payload = step17.payload
        
        // Then
        switch payload {
        case .rating(let ratingPayload):
            XCTAssertEqual(ratingPayload.label, .current)
            XCTAssertNil(ratingPayload.stats) // Should be calculated from answers
        default:
            XCTFail("Step 17 should have rating payload")
        }
    }
    
    func testStep17ValuesFromFlowPayload() {
        // Given
        let flow = FlowManifest.flow
        let step17 = flow[16]
        
        // When/Then - Verify all required properties match TypeScript
        XCTAssertEqual(step17.id, "currentRating")
        XCTAssertEqual(step17.kind, .rating)
        XCTAssertEqual(step17.title, "Your Deeper Voice Rating")
        XCTAssertEqual(step17.subtitle, "Current VoiceMaxxing assessment")
        XCTAssertEqual(step17.artNote, "INSERT ART HERE: Rating dashboard with voice quality metrics")
        
        // Verify payload structure
        switch step17.payload {
        case .rating(let ratingPayload):
            XCTAssertEqual(ratingPayload.label, .current)
            XCTAssertNil(ratingPayload.stats) // Stats calculated from onboarding answers
        default:
            XCTFail("Expected rating payload")
        }
    }
    
    // MARK: - Answers Persistence Tests
    
    func testAnswersPersistence() async {
        // Given
        let testAnswers: [String: CodableValue] = [
            "voiceTrainHours": .double(2.0),
            "breathworkMinutes": .double(15.0),
            "readAloudPages": .double(5.0),
            "aims": .dictionary([
                "reduceVoiceStrain": .bool(true),
                "trainInMorning": .bool(false)
            ])
        ]
        
        // When - Save answers
        for (key, value) in testAnswers {
            onboardingStore.saveAnswer(id: key, value: value)
        }
        
        // Simulate app relaunch
        let newStore = OnboardingStore()
        
        // Wait for hydration
        let expectation = XCTestExpectation(description: "Store hydration")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1.0)
        
        // Then - Verify answers persisted
        XCTAssertEqual(newStore.getAnswer(id: "voiceTrainHours", as: Double.self), 2.0)
        XCTAssertEqual(newStore.getAnswer(id: "breathworkMinutes", as: Double.self), 15.0)
        XCTAssertEqual(newStore.getAnswer(id: "readAloudPages", as: Double.self), 5.0)
        
        // Verify dictionary answers
        let aims = newStore.getAnswer(id: "aims", as: [String: CodableValue].self)
        XCTAssertNotNil(aims)
        XCTAssertEqual(aims?["reduceVoiceStrain"]?.boolValue, true)
        XCTAssertEqual(aims?["trainInMorning"]?.boolValue, false)
    }
    
    // MARK: - Stats Calculation Tests
    
    func testStatsCalculationFromAnswers() {
        // Given
        let answers: [String: CodableValue] = [
            "voiceTrainHours": .double(2.0),
            "breathworkMinutes": .double(15.0),
            "readAloudPages": .double(5.0),
            "loudEnvironmentsHours": .double(1.0),
            "steamHumidifyFrequency": .double(3.0),
            "downGlidesCount": .double(10.0),
            "techniqueStudyDaily": .double(20.0),
            "aims": .dictionary([
                "reduceVoiceStrain": .bool(true),
                "trainInMorning": .bool(false)
            ])
        ]
        
        // When
        let stats = RatingView.calculateStats(from: answers)
        
        // Then - Verify calculation matches TypeScript logic
        // Overall: (2*2) + (15*0.5) + (5*1.5) + (20*0.3) + (true?20:0) + (false?10:0) - (1*3) = 4 + 7.5 + 7.5 + 6 + 20 + 0 - 3 = 42
        XCTAssertEqual(stats.overall, 42)
        
        // Resonance: (2*1.5) + (3*2) + (10*1.2) + (true?15:0) = 3 + 6 + 12 + 15 = 36
        XCTAssertEqual(stats.resonance, 36)
        
        // Breath: (15*1.2) + (3*1.5) + (20*0.4) + (false?8:0) = 18 + 4.5 + 8 + 0 = 30.5 -> 31
        XCTAssertEqual(stats.clarity, 31)
        
        // Technique: (20*1.8) + (2*1.2) + (10*1.0) + (5*0.8) = 36 + 2.4 + 10 + 4 = 52.4 -> 52
        XCTAssertEqual(stats.power, 52)
        
        // Consistency: (2*1.0) + (15*0.8) + (5*1.0) + (false?12:0) + (true?10:0) = 2 + 12 + 5 + 0 + 10 = 29
        XCTAssertEqual(stats.consistency, 29)
        
        // Confidence: (2*1.3) + (20*1.5) + (5*1.2) + (10*0.9) + (false?15:0) = 2.6 + 30 + 6 + 9 + 0 = 47.6 -> 48
        XCTAssertEqual(stats.control, 48)
    }
    
    func testStatsCalculationWithEdgeCases() {
        // Given - All zero values
        let zeroAnswers: [String: CodableValue] = [
            "voiceTrainHours": .double(0.0),
            "breathworkMinutes": .double(0.0),
            "readAloudPages": .double(0.0),
            "loudEnvironmentsHours": .double(0.0),
            "steamHumidifyFrequency": .double(0.0),
            "downGlidesCount": .double(0.0),
            "techniqueStudyDaily": .double(0.0),
            "aims": .dictionary([
                "reduceVoiceStrain": .bool(false),
                "trainInMorning": .bool(false)
            ])
        ]
        
        // When
        let stats = RatingView.calculateStats(from: zeroAnswers)
        
        // Then - All scores should be 0
        XCTAssertEqual(stats.overall, 0)
        XCTAssertEqual(stats.resonance, 0)
        XCTAssertEqual(stats.clarity, 0)
        XCTAssertEqual(stats.power, 0)
        XCTAssertEqual(stats.consistency, 0)
        XCTAssertEqual(stats.control, 0)
    }
    
    func testStatsCalculationWithHighValues() {
        // Given - High values that should cap at 100
        let highAnswers: [String: CodableValue] = [
            "voiceTrainHours": .double(50.0),
            "breathworkMinutes": .double(100.0),
            "readAloudPages": .double(50.0),
            "loudEnvironmentsHours": .double(0.0),
            "steamHumidifyFrequency": .double(50.0),
            "downGlidesCount": .double(50.0),
            "techniqueStudyDaily": .double(50.0),
            "aims": .dictionary([
                "reduceVoiceStrain": .bool(true),
                "trainInMorning": .bool(true)
            ])
        ]
        
        // When
        let stats = RatingView.calculateStats(from: highAnswers)
        
        // Then - All scores should be capped at 100
        XCTAssertLessThanOrEqual(stats.overall, 100)
        XCTAssertLessThanOrEqual(stats.resonance, 100)
        XCTAssertLessThanOrEqual(stats.clarity, 100)
        XCTAssertLessThanOrEqual(stats.power, 100)
        XCTAssertLessThanOrEqual(stats.consistency, 100)
        XCTAssertLessThanOrEqual(stats.control, 100)
    }
    
    // MARK: - Flow Navigation Tests
    
    func testNavigateFromStep16ToStep17() {
        // Given
        onboardingStore.setStepIndex(15) // Step 16
        
        // When
        onboardingStore.next() // Move to Step 17
        
        // Then
        XCTAssertEqual(onboardingStore.stepIndex, 16) // Step 17
        
        // Verify Step 17 properties
        let flow = FlowManifest.flow
        let step17 = flow[16]
        XCTAssertEqual(step17.id, "currentRating")
        XCTAssertEqual(step17.kind, .rating)
    }
    
    func testNavigateFromStep17ToStep18() {
        // Given
        onboardingStore.setStepIndex(16) // Step 17
        
        // When
        onboardingStore.next() // Move to Step 18
        
        // Then
        XCTAssertEqual(onboardingStore.stepIndex, 17) // Step 18
        
        // Verify Step 18 properties
        let flow = FlowManifest.flow
        let step18 = flow[17]
        XCTAssertEqual(step18.id, "potentialRating")
        XCTAssertEqual(step18.kind, .rating)
    }
    
    func testResetReturnsToStep0() {
        // Given
        onboardingStore.setStepIndex(16) // Step 17
        XCTAssertEqual(onboardingStore.stepIndex, 16)
        
        // When
        onboardingStore.reset()
        
        // Then
        XCTAssertEqual(onboardingStore.stepIndex, 0)
        XCTAssertTrue(onboardingStore.answers.isEmpty)
    }
}
