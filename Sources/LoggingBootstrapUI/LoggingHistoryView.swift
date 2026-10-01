//
//  Created by Kurlovich Vitali on 9/28/26.
//

import InMemoryLogging
import Logging
import LoggingBootstrap
import SwiftUI

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

public struct LoggingHistoryView<Content: View>: View {
    private let content: ([LoggingViewMessage]) -> Content

    @State
    private var messages: [LoggingViewMessage] = []

    public init(
        content: @escaping ([LoggingViewMessage]) -> Content
    ) {
        self.content = content
    }

    public var body: some View {
        content(messages)
            .task {
                let bootstrap = LoggingBootstrap.default

                messages = bootstrap.loggingHistory
                    .enumerated()
                    .lazy
                    .reversed()
                    .map {
                        LoggingViewMessage(id: $0.offset, entry: $0.element)
                    }

                for await _ in bootstrap.events {
                    messages = bootstrap.loggingHistory
                        .enumerated()
                        .lazy
                        .reversed()
                        .map {
                            LoggingViewMessage(id: $0.offset, entry: $0.element)
                        }
                }
            }
    }
}
