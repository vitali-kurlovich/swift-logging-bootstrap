//
//  Created by Kurlovich Vitali on 9/28/26.
//

import Logging
import LoggingBootstrap
import SwiftUI

public struct LoggingHistoryView<Content: View>: View {
    private let content: ([LoggingViewMessage]) -> Content

    @State
    private var messages: [LoggingViewMessage] = []

    @Binding
    private var logLevel: Logger.Level

    public init(
        logLevel: Binding<Logger.Level> = .constant(.info),

        content: @escaping ([LoggingViewMessage]) -> Content
    ) {
        self.content = content
        _logLevel = logLevel
    }

    public var body: some View {
        content(filteredMessages)
            .task {
                let bootstrap = LoggingBootstrap.default

                for await _ in bootstrap.loggingEvents(level: .debug) {
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

private extension LoggingHistoryView {
    var filteredMessages: [LoggingViewMessage] {
        messages.filter { $0.level >= logLevel }
    }
}
