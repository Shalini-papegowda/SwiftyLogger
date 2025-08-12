import OSLog
import XCTest
@testable import SwiftyLogger

final class MockLogger: LoggerProtocol, @unchecked Sendable {
    
    struct Entry {
        let level: OSLogType
        let message: String
    }
    private(set) var entries: [Entry] = []
    
    func loggerMessage(_ message: String,_ level: OSLogType) {
        entries.append(.init(level: level, message: message))
    }
    
    func reset() {
        entries.removeAll()
    }
}
