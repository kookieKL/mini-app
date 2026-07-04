import SwiftUI

struct RootView: View {
    @Environment(AppEnvironment.self) private var env

    var body: some View {
        Group {
            switch env.session.state {
            case .loading:
                LoadingView()
            case .signedOut:
                AuthView()
            case .signedIn:
                HomeView()
            }
        }
        .animation(.easeInOut, value: env.session.state)
    }
}

struct LoadingView: View {
    var body: some View {
        ProgressView()
            .tint(Theme.accent)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .krafBackground()
    }
}
