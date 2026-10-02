//
//  Created by Kurlovich Vitali on 10/2/26.
//

import InMemoryLogging
import Logging

public struct LoggingViewMessage: Identifiable {
    public let id: Int
    private let entry: InMemoryLogHandler.Entry

    init(id: Int, entry: InMemoryLogHandler.Entry) {
        self.id = id
        self.entry = entry
    }
}

public extension LoggingViewMessage {
    var description: String {
        message.description
    }

    var level: Logger.Level {
        entry.level
    }

    var error: (any Error)? {
        entry.error
    }

    var message: Logger.Message {
        entry.message
    }

    var metadata: Logger.Metadata {
        entry.metadata
    }
}
