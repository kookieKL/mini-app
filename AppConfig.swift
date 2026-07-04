import Foundation

/// Central place for non-secret public configuration.
/// In production prefer moving these into an .xcconfig / Build Settings.
enum AppConfig {
    // MARK: Supabase
    static let supabaseURL = URL(string: "https://your-project-ref.supabase.co")!
    static let supabaseAnonKey = "your-anon-key"

    // MARK: RevenueCat
    /// Public Apple API key, starts with `appl_`. Safe to ship in the binary.
    static let revenueCatPublicKey = "appl_your_public_key"
    /// Entitlement identifier configured in the RevenueCat dashboard.
    static let proEntitlementId = "pro"

    // MARK: Sentry
    static let sentryDSN = "https://your-ios-dsn.ingest.sentry.io/123"

    // MARK: Edge Functions
    static let recommendFunctionName = "recommend"

    // MARK: Business rules (mirror of backend FREE_QUIZ_LIMIT, for UI hints only)
    static let freeQuizLimit = 2
}
