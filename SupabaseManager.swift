import Foundation
import Supabase

/// Singleton wrapper around the Supabase client.
/// Holds the shared `SupabaseClient` used by all services.
final class SupabaseManager {
    static let shared = SupabaseManager()

    let client: SupabaseClient

    private init() {
        client = SupabaseClient(
            supabaseURL: AppConfig.supabaseURL,
            supabaseKey: AppConfig.supabaseAnonKey
        )
    }
}
