import Foundation
import Observation

@MainActor
@Observable
final class AuthViewModel {
    enum Mode {
        case signIn
        case signUp

        var title: String { self == .signIn ? "Вход" : "Регистрация" }
        var actionTitle: String { self == .signIn ? "Войти" : "Создать аккаунт" }
        var switchPrompt: String {
            self == .signIn ? "Нет аккаунта? Зарегистрироваться" : "Уже есть аккаунт? Войти"
        }
    }

    var mode: Mode = .signIn
    var email = ""
    var password = ""
    var isLoading = false
    var errorMessage: String?

    private let auth = AuthService()
    private let appleCoordinator = AppleSignInCoordinator()

    var canSubmit: Bool {
        email.contains("@") && password.count >= 6 && !isLoading
    }

    func toggleMode() {
        mode = mode == .signIn ? .signUp : .signIn
        errorMessage = nil
    }

    func submit() async {
        guard canSubmit else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            switch mode {
            case .signIn:
                try await auth.signIn(email: email, password: password)
            case .signUp:
                try await auth.signUp(email: email, password: password)
            }
        } catch {
            Telemetry.capture(error, context: ["stage": "auth.\(mode == .signIn ? "signIn" : "signUp")"])
            errorMessage = friendly(error)
        }
    }

    func signInWithApple() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            let credential = try await appleCoordinator.signIn()
            try await auth.signInWithApple(
                idToken: credential.idToken,
                nonce: credential.nonce
            )
        } catch is CancellationError {
            // user cancelled, ignore
        } catch {
            Telemetry.capture(error, context: ["stage": "auth.apple"])
            errorMessage = friendly(error)
        }
    }

    private func friendly(_ error: Error) -> String {
        if let localized = (error as? LocalizedError)?.errorDescription {
            return localized
        }
        return "Что-то пошло не так. Попробуйте ещё раз."
    }
}
