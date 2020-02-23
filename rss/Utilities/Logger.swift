//
//  Copyright © 2020 Objective Swift Inc. All rights reserved.
//

import Foundation

/// Contains logging utilities.
public struct Logger {

    // MARK: - Public

    /// Logging levels as an enum. These encourage clear logging intentions.
    public enum LogLevel {

        /// Default, general debugging (only shows if DEBUG is set).
        case debug

        /// General debugging that we show even when not in debug.
        case info

        /// Something looks wrong, but non-fatal.
        case warning

        /// Something is fatally wrong, could be a crash.
        case error
    }

    /// Basic logging, nothing fancy for now. Could be hooked up to Fabric or something later.
    /// Defaults to debug level.
    public static func log(_ level: LogLevel = .debug, message: String) {
        switch level {
        case .debug:
            #if DEBUG
            log("DEBUG: " + message)
            #endif
        case .info:
            log("INFO: " + message)
        case .warning:
            log("WARNING: " + message)
        case .error:
            log("ERROR: " + message)
        }
    }

    // MARK: - Private

    /// This does the actual logging.
    /// Good place to add globally logging policies (i.e. don't log API tokens).
    private static func log(file: StaticString = #file, line: Int = #line, _ message: String) {
        print(format(file: file, line: line, message: message))
    }

    /// Formats our logging output.
    private static func format(file: StaticString, line: Int, message: String) -> String {
        if let filename = URL(string: String(describing: file))?.lastPathComponent.components(separatedBy: ".").first {
            return "\(filename) line \(line) $ \(message)"
        } else {
            return "\(file) line \(line) $ \(message)"
        }
    }
}
