// The Swift Programming Language
// https://docs.swift.org/swift-book

import OSLog

public actor SwiftyLogger {
    
    /// The underlying logger conforming to LoggerProtocol used for actual logging.
    private let logger: LoggerProtocol
    
    /// A shared singleton instance for global access.
    public static let shared = SwiftyLogger()
    
    /// Initializes the SwiftyLogger with a custom LoggerProtocol instance.
    /// - Parameter logger: The logger to use; defaults to `Logger` from os framework
    ///   configured with the app’s bundle identifier and a default category.
    public init(_ logger: LoggerProtocol = Logger(subsystem: Bundle.main.bundleIdentifier ?? "SwiftyLogger", category: "Default")) {
        self.logger = logger
    }
    
    /// Internal method that formats the message and sends it to the underlying logger.
    /// Runs inside actor isolation to ensure thread safety.
    /// - Parameters:
    ///   - message: The message string to log.
    ///   - level: The OSLogType (e.g., debug, info, error) for the log level.
    ///   - file: The source file where log was called (defaults to caller’s file).
    ///   - function: The function name where log was called (defaults to caller’s function).
    ///   - line: The line number where log was called (defaults to caller’s line).
    private func logMessage(_ message: String, level: OSLogType, file: String, function: String, line: Int) {
        let source = "[\((file as NSString).lastPathComponent):\(line) \(function)]"
        let formattedMessage = "\(source) \(message)"
        logger.loggerMessage(formattedMessage, level)
    }
    
    /// Asynchronous logging method that safely logs messages on the actor.
    public func logAsync(_ message: String,
                         level: OSLogType = .default,
                         file: String = #file,
                         function: String = #function,
                         line: Int = #line) async {
        // Call the internal isolated logging method
        logMessage(message, level: level, file: file, function: function, line: line)
    }
    
    /// Synchronous logging method callable from any thread without awaiting.
    /// It internally starts a Task to call the async actor-isolated logging method.
    public nonisolated func log(_ message: String,
                                level: OSLogType = .default,
                                file: String = #file,
                                function: String = #function,
                                line: Int = #line) {
        // Use a Task to call the actor-isolated async log method safely
        Task { [weak self] in
            guard let self else { return }
            await self.logMessage(message, level: level, file: file, function: function, line: line)
        }
    }
}
