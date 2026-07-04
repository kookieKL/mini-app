import Foundation
import Supabase
import Observation

/// Observable source of truth for the current auth session.
@MainActor
@Observable
final class SessionStore {
    enum State: Equatable {
        case loading
        case signedOut
        case signedIn(userId: String)
    }

    private(set) var state: State = .loading

    var userId: String? {
        if case let .signedIn(id) = state { return id }
        return nil
    }

    var isSignedIn: Bool { userId != nil }

    private let auth = AuthService()
    private var observationTask: Task<Void, Never>?

    func start() {
        observationTask?.cancel()
        observationTask = Task { [weak self] in
            guard let self else { return }
            // Initial session.
            if let session = await auth.currentSession() {
                self.state = .signedIn(userId: session.user.id.uuidString.lowercased())
            } else {
                self.state = .signedOut
            }
            // Observe changes.
            for await change in await auth.authStateChanges() {
                switch change.event {
                case .signedIn, .tokenRefreshed, .userUpdated:
                    if let session = change.session {
                        self.state = .signedIn(userId: session.user.id.uuidString.lowercased())
                    }
                case .signedOut:
                    self.state = .signedOut
                default:
                    break
                }
            }
        }
    }

    func signOut() async {
        try? await auth.signOut()
        state = .signedOut
    }
}
