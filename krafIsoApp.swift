import SwiftUI
import RevenueCat
import Sentry

@main
struct krafIsoApp: App {
    @State private var environment = AppEnvironment()

    init() {
        Self.configureSentry()
        Self.configureRevenueCat()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(environment)
                .task { environment.start() }
                .preferredColorScheme(.dark)
        }
    }

    private static func configureSentry() {
        SentrySDK.start { options in
            options.dsn = AppConfig.sentryDSN
            options.tracesSampleRate = 0.2
            #if DEBUG
            options.debug = true
            options.environment = "debug"
            #else
            options.environment = "production"
            #endif
        }
    }

    private static func configureRevenueCat() {
        #if DEBUG
        Purchases.logLevel = .debug
        #endif
        Purchases.configure(withAPIKey: AppConfig.revenueCatPublicKey)
    }
}
