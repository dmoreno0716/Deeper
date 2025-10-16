import XCTest
@testable import Deeper

/// Unit tests for Stats decoding from JSON payload
final class StatsDecodingTests: XCTestCase {
    
    // MARK: - Test Data
    
    private let validStatsJSON = """
    {
        "overall": 75,
        "depth": 80,
        "resonance": 70,
        "clarity": 85,
        "power": 65,
        "control": 90,
        "consistency": 78
    }
    """
    
    private let minimalStatsJSON = """
    {
        "overall": 0,
        "depth": 0,
        "resonance": 0,
        "clarity": 0,
        "power": 0,
        "control": 0,
        "consistency": 0
    }
    """
    
    private let maxStatsJSON = """
    {
        "overall": 100,
        "depth": 100,
        "resonance": 100,
        "clarity": 100,
        "power": 100,
        "control": 100,
        "consistency": 100
    }
    """
    
    // MARK: - Valid Stats Tests
    
    func testDecodeValidStats() throws {
        // Given
        let jsonData = validStatsJSON.data(using: .utf8)!
        
        // When
        let stats = try JSONDecoder().decode(Stats.self, from: jsonData)
        
        // Then
        XCTAssertEqual(stats.overall, 75)
        XCTAssertEqual(stats.depth, 80)
        XCTAssertEqual(stats.resonance, 70)
        XCTAssertEqual(stats.clarity, 85)
        XCTAssertEqual(stats.power, 65)
        XCTAssertEqual(stats.control, 90)
        XCTAssertEqual(stats.consistency, 78)
    }
    
    func testDecodeMinimalStats() throws {
        // Given
        let jsonData = minimalStatsJSON.data(using: .utf8)!
        
        // When
        let stats = try JSONDecoder().decode(Stats.self, from: jsonData)
        
        // Then
        XCTAssertEqual(stats.overall, 0)
        XCTAssertEqual(stats.depth, 0)
        XCTAssertEqual(stats.resonance, 0)
        XCTAssertEqual(stats.clarity, 0)
        XCTAssertEqual(stats.power, 0)
        XCTAssertEqual(stats.control, 0)
        XCTAssertEqual(stats.consistency, 0)
    }
    
    func testDecodeMaxStats() throws {
        // Given
        let jsonData = maxStatsJSON.data(using: .utf8)!
        
        // When
        let stats = try JSONDecoder().decode(Stats.self, from: jsonData)
        
        // Then
        XCTAssertEqual(stats.overall, 100)
        XCTAssertEqual(stats.depth, 100)
        XCTAssertEqual(stats.resonance, 100)
        XCTAssertEqual(stats.clarity, 100)
        XCTAssertEqual(stats.power, 100)
        XCTAssertEqual(stats.control, 100)
        XCTAssertEqual(stats.consistency, 100)
    }
    
    // MARK: - Invalid Stats Tests
    
    func testDecodeStatsWithMissingField() {
        // Given
        let invalidJSON = """
        {
            "overall": 75,
            "depth": 80,
            "resonance": 70,
            "clarity": 85,
            "power": 65,
            "control": 90
        }
        """
        let jsonData = invalidJSON.data(using: .utf8)!
        
        // When/Then
        XCTAssertThrowsError(try JSONDecoder().decode(Stats.self, from: jsonData)) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }
    
    func testDecodeStatsWithInvalidType() {
        // Given
        let invalidJSON = """
        {
            "overall": "not_a_number",
            "depth": 80,
            "resonance": 70,
            "clarity": 85,
            "power": 65,
            "control": 90,
            "consistency": 78
        }
        """
        let jsonData = invalidJSON.data(using: .utf8)!
        
        // When/Then
        XCTAssertThrowsError(try JSONDecoder().decode(Stats.self, from: jsonData)) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }
    
    func testDecodeStatsWithNegativeValues() throws {
        // Given
        let negativeStatsJSON = """
        {
            "overall": -10,
            "depth": -5,
            "resonance": 0,
            "clarity": 85,
            "power": 65,
            "control": 90,
            "consistency": 78
        }
        """
        let jsonData = negativeStatsJSON.data(using: .utf8)!
        
        // When
        let stats = try JSONDecoder().decode(Stats.self, from: jsonData)
        
        // Then
        XCTAssertEqual(stats.overall, -10)
        XCTAssertEqual(stats.depth, -5)
        XCTAssertEqual(stats.resonance, 0)
        XCTAssertEqual(stats.clarity, 85)
        XCTAssertEqual(stats.power, 65)
        XCTAssertEqual(stats.control, 90)
        XCTAssertEqual(stats.consistency, 78)
    }
    
    func testDecodeStatsWithValuesOver100() throws {
        // Given
        let overMaxStatsJSON = """
        {
            "overall": 150,
            "depth": 200,
            "resonance": 70,
            "clarity": 85,
            "power": 65,
            "control": 90,
            "consistency": 78
        }
        """
        let jsonData = overMaxStatsJSON.data(using: .utf8)!
        
        // When
        let stats = try JSONDecoder().decode(Stats.self, from: jsonData)
        
        // Then
        XCTAssertEqual(stats.overall, 150)
        XCTAssertEqual(stats.depth, 200)
        XCTAssertEqual(stats.resonance, 70)
        XCTAssertEqual(stats.clarity, 85)
        XCTAssertEqual(stats.power, 65)
        XCTAssertEqual(stats.control, 90)
        XCTAssertEqual(stats.consistency, 78)
    }
    
    // MARK: - Encoding Tests
    
    func testEncodeStats() throws {
        // Given
        let stats = Stats(
            overall: 75,
            depth: 80,
            resonance: 70,
            clarity: 85,
            power: 65,
            control: 90,
            consistency: 78
        )
        
        // When
        let jsonData = try JSONEncoder().encode(stats)
        let decodedStats = try JSONDecoder().decode(Stats.self, from: jsonData)
        
        // Then
        XCTAssertEqual(decodedStats.overall, stats.overall)
        XCTAssertEqual(decodedStats.depth, stats.depth)
        XCTAssertEqual(decodedStats.resonance, stats.resonance)
        XCTAssertEqual(decodedStats.clarity, stats.clarity)
        XCTAssertEqual(decodedStats.power, stats.power)
        XCTAssertEqual(decodedStats.control, stats.control)
        XCTAssertEqual(decodedStats.consistency, stats.consistency)
    }
    
    // MARK: - Equatable Tests
    
    func testStatsEquality() {
        // Given
        let stats1 = Stats(
            overall: 75,
            depth: 80,
            resonance: 70,
            clarity: 85,
            power: 65,
            control: 90,
            consistency: 78
        )
        
        let stats2 = Stats(
            overall: 75,
            depth: 80,
            resonance: 70,
            clarity: 85,
            power: 65,
            control: 90,
            consistency: 78
        )
        
        let stats3 = Stats(
            overall: 76,
            depth: 80,
            resonance: 70,
            clarity: 85,
            power: 65,
            control: 90,
            consistency: 78
        )
        
        // Then
        XCTAssertEqual(stats1, stats2)
        XCTAssertNotEqual(stats1, stats3)
    }
    
    // MARK: - RatingPayload Tests
    
    func testDecodeRatingPayload() throws {
        // Given
        let ratingPayloadJSON = """
        {
            "label": "current",
            "stats": {
                "overall": 75,
                "depth": 80,
                "resonance": 70,
                "clarity": 85,
                "power": 65,
                "control": 90,
                "consistency": 78
            }
        }
        """
        let jsonData = ratingPayloadJSON.data(using: .utf8)!
        
        // When
        let payload = try JSONDecoder().decode(RatingPayload.self, from: jsonData)
        
        // Then
        XCTAssertEqual(payload.label, .current)
        XCTAssertNotNil(payload.stats)
        XCTAssertEqual(payload.stats?.overall, 75)
        XCTAssertEqual(payload.stats?.depth, 80)
        XCTAssertEqual(payload.stats?.resonance, 70)
        XCTAssertEqual(payload.stats?.clarity, 85)
        XCTAssertEqual(payload.stats?.power, 65)
        XCTAssertEqual(payload.stats?.control, 90)
        XCTAssertEqual(payload.stats?.consistency, 78)
    }
    
    func testDecodeRatingPayloadWithoutStats() throws {
        // Given
        let ratingPayloadJSON = """
        {
            "label": "potential"
        }
        """
        let jsonData = ratingPayloadJSON.data(using: .utf8)!
        
        // When
        let payload = try JSONDecoder().decode(RatingPayload.self, from: jsonData)
        
        // Then
        XCTAssertEqual(payload.label, .potential)
        XCTAssertNil(payload.stats)
    }
    
    // MARK: - Step Payload Tests
    
    func testDecodeStepPayloadWithRating() throws {
        // Given
        let stepPayloadJSON = """
        {
            "label": "current",
            "stats": {
                "overall": 75,
                "depth": 80,
                "resonance": 70,
                "clarity": 85,
                "power": 65,
                "control": 90,
                "consistency": 78
            }
        }
        """
        let jsonData = stepPayloadJSON.data(using: .utf8)!
        
        // When
        let payload = try JSONDecoder().decode(StepPayload.self, from: jsonData)
        
        // Then
        switch payload {
        case .rating(let ratingPayload):
            XCTAssertEqual(ratingPayload.label, .current)
            XCTAssertNotNil(ratingPayload.stats)
            XCTAssertEqual(ratingPayload.stats?.overall, 75)
        default:
            XCTFail("Expected rating payload")
        }
    }
    
    // MARK: - Flow Manifest Tests
    
    func testStep17IsCurrentRating() {
        // Given
        let flow = FlowManifest.flow
        
        // When
        let step17 = flow[16] // 0-indexed, so step 17 is index 16
        
        // Then
        XCTAssertEqual(step17.id, "currentRating")
        XCTAssertEqual(step17.kind, .rating)
        XCTAssertEqual(step17.title, "Your Deeper Voice Rating")
        XCTAssertEqual(step17.subtitle, "Current VoiceMaxxing assessment")
        
        // Check payload
        switch step17.payload {
        case .rating(let ratingPayload):
            XCTAssertEqual(ratingPayload.label, .current)
            XCTAssertNil(ratingPayload.stats) // Stats should be calculated from answers
        default:
            XCTFail("Expected rating payload for step 17")
        }
    }
    
    func testStep18IsPotentialRating() {
        // Given
        let flow = FlowManifest.flow
        
        // When
        let step18 = flow[17] // 0-indexed, so step 18 is index 17
        
        // Then
        XCTAssertEqual(step18.id, "potentialRating")
        XCTAssertEqual(step18.kind, .rating)
        XCTAssertEqual(step18.title, "Potential Rating")
        XCTAssertEqual(step18.subtitle, "Your VoiceMaxxing potential")
        
        // Check payload
        switch step18.payload {
        case .rating(let ratingPayload):
            XCTAssertEqual(ratingPayload.label, .potential)
            XCTAssertNil(ratingPayload.stats) // Stats should be calculated from answers
        default:
            XCTFail("Expected rating payload for step 18")
        }
    }
}
