import OSLog
import XCTest
@testable import SwiftyLogger

final class SwiftyLoggerTests: XCTestCase {
    
    var mockLogger: MockLogger!
    var swiftyLogger: SwiftyLogger!
    
    override func setUp() {
        super.setUp()
        mockLogger = MockLogger()
        swiftyLogger = SwiftyLogger(mockLogger)
    }
    
    override func tearDown() {
        swiftyLogger = nil
        mockLogger = nil
        super.tearDown()
    }
    
    func test_logMessage_formatsAndLogsCorrectly() async {
        await swiftyLogger.logAsync("Test message", level: .info, file: "File.swift", function: "func()", line: 42)
        
        XCTAssertEqual(mockLogger.entries.count, 1)
        
        let entry = mockLogger.entries.first!
        XCTAssertEqual(entry.level, .info)
        XCTAssertTrue(entry.message.contains("File.swift:42 func()"))
        XCTAssertTrue(entry.message.contains("Test message"))
    }
    
    func test_logAsync_and_log_sendsCorrectLog() async {
        swiftyLogger.log("Sync test message", level: .debug, file: "SyncFile.swift", function: "syncFunc()", line: 10)
        
        try? await Task.sleep(nanoseconds: 200_000_000) // 0.2 seconds
        XCTAssertEqual(mockLogger.entries.count, 1)
        
        let entry = mockLogger.entries.first!
        XCTAssertEqual(entry.level, .debug)
        XCTAssertTrue(entry.message.contains("SyncFile.swift:10 syncFunc()"))
        XCTAssertTrue(entry.message.contains("Sync test message"))
    }
    
    func test_multipleLogLevels_areLoggedProperly() async {
        let levels: [OSLogType] = [.debug, .info, .error, .fault, .default]
        
        for level in levels {
            await swiftyLogger.logAsync("Level \(level) test", level: level)
        }
        XCTAssertEqual(mockLogger.entries.count, levels.count)
        
        for (index, level) in levels.enumerated() {
            XCTAssertEqual(mockLogger.entries[index].level, level)
            XCTAssertTrue(mockLogger.entries[index].message.contains("Level \(level) test"))
        }
    }
    
    func test_loggerMessage_withDifferentLevels_doesNotCrash() {
        let logger = Logger(subsystem: "com.test.logger", category: "unitTest")
        
        let levels: [OSLogType] = [.debug, .info, .error, .fault, .default]
        
        for level in levels {
            logger.loggerMessage("Test message for level \(level)", level)
            XCTAssertNotNil(logger)
        }
    }
}
