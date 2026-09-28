//
//  Created by Kurlovich Vitali on 6/2/26.
//

import Foundation
import Logging

public final class LogEventsReporterHandler: LogHandler, @unchecked Sendable {
    public var metadata: Logger.Metadata = [:]
    public var metadataProvider: Logger.MetadataProvider?
    public var logLevel: Logger.Level = .info

    private let eventsStream: AsyncStream<LogEvent>
    private let continuation: AsyncStream<LogEvent>.Continuation

    public init(
        metadata: Logger.Metadata = [:],
        metadataProvider: Logger.MetadataProvider? = nil,
        logLevel: Logger.Level = .info
    ) {
        self.metadata = metadata
        self.metadataProvider = metadataProvider
        self.logLevel = logLevel

        let (stream, continuation) = AsyncStream.makeStream(of: LogEvent.self)
        eventsStream = stream
        self.continuation = continuation
    }

    public var events: AsyncStream<LogEvent> {
        AsyncStream<LogEvent> { continuation in
            let task = Task {
                for await event in self.eventsStream {
                    continuation.yield(event)
                }
                continuation.finish()
            }

            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }

    public func log(event: LogEvent) {
        continuation.yield(event)
    }

    public subscript(metadataKey key: String) -> Logger.Metadata.Value? {
        get {
            metadata[key]
        }
        set {
            metadata[key] = newValue
        }
    }
}
