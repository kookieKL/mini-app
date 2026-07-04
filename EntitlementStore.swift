import Foundation
import Observation
import RevenueCat

/// Tracks the user's `pro` entitlement via RevenueCat for instant UI gating.
/// The backend `subscriptions` table (synced by webhook) remains the source of
/// truth for the recommend function's quota check.
@MainActor
@Observable
final class EntitlementStore {
    private(set) var isPro = false
    private(set) var isLoading = false

    /// Align RevenueCat's appUserID with the Supabase user id so the webhook can
    /// map purchases back to the right row.
    func identify(userId: String) async {
        do {
            let (customerInfo, _) = try await Purchases.shared.logIn(userId)
            updateState(from: customerInfo)
        } catch {
            await refresh()
        }
    }

    func refresh() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let info = try await Purchases.shared.customerInfo()
            updateState(from: info)
        } catch {
            // keep last known state
        }
    }

    func logout() async {
        _ = try? await Purchases.shared.logOut()
        isPro = false
    }

    private func updateState(from info: CustomerInfo) {
        isPro = info.entitlements[AppConfig.proEntitlementId]?.isActive == true
    }
}
