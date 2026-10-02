//
//  Created by Kurlovich Vitali on 10/2/26.
//

import Logging
import SwiftUI

public struct LoggerLevelPicker: View {
    @Binding
    private var logLevel: Logger.Level

    public init(
        logLevel: Binding<Logger.Level> = .constant(.info)
    ) {
        _logLevel = logLevel
    }

    public var body: some View {
        Picker("Logger Level", selection: $logLevel) {
            Label("Critical", systemImage: "exclamationmark.octagon.fill")
                .foregroundStyle(Color.red.gradient)
                .tag(Logger.Level.critical)

            Label("Error", systemImage: "exclamationmark.octagon.fill")
                .foregroundStyle(Color.red.gradient)
                .tag(Logger.Level.error)

            Label("Warning", systemImage: "exclamationmark.triangle.fill")
                .foregroundStyle(Color.orange.gradient)
                .tag(Logger.Level.warning)

            Label("Notice", systemImage: "info.circle.fill")
                .foregroundStyle(Color.blue.gradient)
                .tag(Logger.Level.notice)

            Label("Info", systemImage: "info.circle.fill")
                .foregroundStyle(Color.blue.gradient)
                .tag(Logger.Level.info)

            Label("Debug", systemImage: "info.circle")
                .foregroundStyle(Color.green.gradient)
                .tag(Logger.Level.debug)

            Label("Trace", systemImage: "info.circle")
                .foregroundStyle(Color.green.gradient)
                .tag(Logger.Level.trace)
        }
    }
}

#Preview {
    @Previewable @State
    var logLevel: Logger.Level = .trace
    LoggerLevelPicker(logLevel: $logLevel)
}
