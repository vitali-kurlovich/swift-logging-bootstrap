//
//  Created by Kurlovich Vitali on 6/1/26.
//

#if os(anyAppleOS)

    import Logging
    import OSLog

public struct OSLogHandler: LogHandler {
    
    public init(
        label: String,
        subsystem: String,
        metadata: Logging.Logger.Metadata = [:],
        logLevel: Logging.Logger.Level = .debug
    ) {
        self.label = label
        self.subsystem = subsystem
        self.metadata = metadata
        self.logLevel = logLevel
    }
    
    public let label: String
    public let subsystem: String

    public  var metadata: Logging.Logger.Metadata

    public  var logLevel: Logging.Logger.Level

    public  subscript(metadataKey key: String) -> Logging.Logger.Metadata.Value? {
            get {
                metadata[key]
            }
            set {
                metadata[key] = newValue
            }
        }

    public  func log(event: LogEvent) {
            let logger = Logger(subsystem: subsystem, category: label)

            let level = OSLogType(event.level)

            logger.log(level: level, "\(event.message.description)")
        }
    }

    extension OSLogType {
        public  nonisolated init(_ type: Logging.Logger.Level) {
            switch type {
            case .trace:
                self = .debug
            case .debug:
                self = .debug
            case .info:
                self = .info
            case .notice:
                self = .info
            case .warning:
                self = .error
            case .error:
                self = .error
            case .critical:
                self = .fault
            }
        }
    }

#endif
