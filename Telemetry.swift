import Foundation
import Sentry

/// Thin wrapper over Sentry so feature code doesn't import the SDK directly.
enum Telemetry {
    static func breadcrumb(_ message: String, category: String = "app") {
        let crumb = Breadcrumb(level: .info, category: category)
        crumb.message = message
        SentrySDK.addBreadcrumb(crumb)
    }

    static func capture(_ error: Error, context: [String: Any] = [:]) {
        SentrySDK.capture(error: error) { scope in
            if !context.isEmpty {
                scope.setContext(value: context, key: "details")
            }
        }
    }
}
