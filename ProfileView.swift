import SwiftUI

struct ProfileView: View {
    @Environment(AppEnvironment.self) private var env
    @Environment(\.dismiss) private var dismiss
    @State private var showPaywall = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    subscriptionCard
                    if !env.entitlements.isPro {
                        upgradeButton
                    }
                    signOutButton
                }
                .padding(24)
            }
            .krafBackground()
            .navigationTitle("Профиль")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Готово") { dismiss() }
                        .foregroundStyle(Theme.accent)
                }
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
        }
        .tint(Theme.accent)
    }

    private var subscriptionCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: env.entitlements.isPro ? "crown.fill" : "sparkles")
                    .foregroundStyle(Theme.accent)
                Text(env.entitlements.isPro ? "krafIso Pro" : "Бесплатный тариф")
                    .fontWeight(.semibold)
            }
            Text(env.entitlements.isPro
                 ? "Спасибо за поддержку! Проходи тест без ограничений."
                 : "После \(AppConfig.freeQuizLimit) прохождений нужна подписка $9.99/мес.")
                .font(.footnote)
                .foregroundStyle(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .krafCard()
        .foregroundStyle(Theme.textPrimary)
    }

    private var upgradeButton: some View {
        Button {
            showPaywall = true
        } label: {
            Text("Оформить подписку")
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Theme.accent, in: RoundedRectangle(cornerRadius: 12))
                .foregroundStyle(.white)
        }
    }

    private var signOutButton: some View {
        Button(role: .destructive) {
            Task {
                await env.entitlements.logout()
                await env.session.signOut()
            }
        } label: {
            Text("Выйти")
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 12))
                .foregroundStyle(.red)
        }
    }
}
