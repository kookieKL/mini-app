import Foundation
import Observation

/// Aggregates global observable stores and injects them into the view tree.
@MainActor
@Observable
final class AppEnvironment {
    let session = SessionStore()
    let entitlements = EntitlementStore()

    func start() {
        session.start()
        Task { await entitlements.refresh() }
    }
}
