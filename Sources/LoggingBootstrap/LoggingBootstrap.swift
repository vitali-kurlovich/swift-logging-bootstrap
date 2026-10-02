//
//  Created by Kurlovich Vitali on 9/28/26.
//

import Foundation
import InMemoryLogging
import Logging

public final class LoggingBootstrap: @unchecked Sendable {
    var inMemoryHandler = InMemoryLogHandler()
    private let eventsReporterHandler = LogEventsReporterHandler()

    private init() {}
}

public extension LoggingBootstrap {
    static let `default` = LoggingBootstrap()
}

public extension LoggingBootstrap {
    typealias Entry = InMemoryLogHandler.Entry

    var loggingHistory: [Entry] {
        inMemoryHandler.entries
    }

    var loggingEvents: AsyncStream<LogEvent> {
        eventsReporterHandler.loggingEvents
    }

    func loggingEvents(level: Logger.Level) -> AsyncStream<LogEvent> {
        eventsReporterHandler.loggingEvents(level: level)
    }
}

public extension LoggingBootstrap {
    struct Options: OptionSet, Sendable {
        public var rawValue: UInt8

        public init(rawValue: UInt8) {
            self.rawValue = rawValue
        }

        #if os(anyAppleOS)
            public static let osLog: Self = .init(rawValue: 1 << 0)
        #endif
        public static let eventsReporter: Self = .init(rawValue: 1 << 1)
        public static let inMemoryLog: Self = .init(rawValue: 1 << 2)

        public static let none: Self = []

        #if os(anyAppleOS)
            public static let all: Self = [.osLog, .eventsReporter, .inMemoryLog]
        #else
            public static let all: Self = [.eventsReporter, .inMemoryLog]
        #endif
    }
}

public extension LoggingBootstrap {
    func bootstrap(
        options: Options = .all,
        logLevel: Logger.Level = .info,
        _ factory: @escaping @Sendable (String) -> (any LogHandler)? = { _ in nil }
    ) {
        inMemoryHandler.logLevel = logLevel
        eventsReporterHandler.logLevel = logLevel
        LoggingSystem.bootstrap { [inMemoryHandler, eventsReporterHandler] label in
            var logHandlers: [any LogHandler] = []

            if let handler = factory(label) {
                logHandlers.append(handler)
            }

            #if os(anyAppleOS)
                if options.contains(.osLog) {
                    let osLogHandler = OSLogHandler(label: label, subsystem: "OSLog", metadata: .init(), logLevel: .debug)

                    logHandlers.append(osLogHandler)
                }
            #endif

            if options.contains(.inMemoryLog) {
                logHandlers.append(inMemoryHandler)
            }

            if options.contains(.eventsReporter) {
                logHandlers.append(eventsReporterHandler)
            }

            return MultiplexLogHandler(logHandlers)
        }
    }
}
