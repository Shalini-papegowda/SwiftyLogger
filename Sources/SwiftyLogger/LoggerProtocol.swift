import OSLog

public protocol LoggerProtocol {
    /// Logs a message with a specified level and privacy setting.
    /// - Parameters:
    ///   - message: The message string to log.
    ///   - level: The OSLogType (e.g., debug, info, error) for the log level.
    func loggerMessage(_ message: String, _ level: OSLogType)
}

/// Extends `Logger` to conform to `LoggerProtocol`, adapting its methods.
extension Logger: LoggerProtocol {
    public func loggerMessage(_ message: String,_ level: OSLogType) {
        switch level {
        case .info:
            self.info("[INFO] \(message, privacy: .public)")
        case .error:
            self.error("[ERROR] \(message, privacy: .public)")
        case .fault:
            self.fault("[FAULT] \(message, privacy: .public)")
        case .debug:
            self.debug("[DEBUG] \(message, privacy: .public)")
        default:
            self.log("\(message, privacy: .public)")
        }
    }
}
