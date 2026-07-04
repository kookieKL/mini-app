import SwiftUI
import AuthenticationServices

struct AuthView: View {
    @State private var viewModel = AuthViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                header

                VStack(spacing: 16) {
                    fields
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .font(.footnote)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    submitButton
                    switchModeButton
                }
                .krafCard()

                divider
                appleButton
            }
            .padding(24)
        }
        .scrollDismissesKeyboard(.interactively)
        .foregroundStyle(Theme.textPrimary)
        .krafBackground()
    }

    private var header: some View {
        VStack(spacing: 10) {
            Text("krafIso")
                .font(.system(size: 40, weight: .bold, design: .serif))
            Text("Книга, подобранная под тебя")
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
        }
        .padding(.top, 40)
    }

    private var fields: some View {
        VStack(spacing: 12) {
            TextField("Email", text: $viewModel.email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(14)
                .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 12))

            SecureField("Пароль", text: $viewModel.password)
                .textContentType(viewModel.mode == .signUp ? .newPassword : .password)
                .padding(14)
                .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 12))
        }
    }

    private var submitButton: some View {
        Button {
            Task { await viewModel.submit() }
        } label: {
            ZStack {
                if viewModel.isLoading {
                    ProgressView().tint(.white)
                } else {
                    Text(viewModel.mode.actionTitle).fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Theme.accent, in: RoundedRectangle(cornerRadius: 12))
            .foregroundStyle(.white)
        }
        .disabled(!viewModel.canSubmit)
        .opacity(viewModel.canSubmit ? 1 : 0.5)
    }

    private var switchModeButton: some View {
        Button(viewModel.mode.switchPrompt) {
            viewModel.toggleMode()
        }
        .font(.footnote)
        .foregroundStyle(Theme.textSecondary)
    }

    private var divider: some View {
        HStack {
            Rectangle().fill(Color.white.opacity(0.12)).frame(height: 1)
            Text("или").font(.footnote).foregroundStyle(Theme.textSecondary)
            Rectangle().fill(Color.white.opacity(0.12)).frame(height: 1)
        }
    }

    private var appleButton: some View {
        SignInWithAppleButton(.continue) { _ in
            // Configuration handled inside the coordinator; we trigger our own flow.
        } onCompletion: { _ in }
        .signInWithAppleButtonStyle(.white)
        .frame(height: 50)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            // Transparent tap layer to route through our coordinator (gives us
            // the nonce required by Supabase).
            Button {
                Task { await viewModel.signInWithApple() }
            } label: {
                Color.clear
            }
        )
    }
}
