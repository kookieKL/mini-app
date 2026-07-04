import SwiftUI

struct HomeView: View {
    @Environment(AppEnvironment.self) private var env
    @State private var showProfile = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    hero
                    statusCard
                    startCard
                    howItWorks
                }
                .padding(24)
            }
            .krafBackground()
            .navigationTitle("krafIso")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showProfile = true
                    } label: {
                        Image(systemName: "person.crop.circle")
                            .foregroundStyle(Theme.textPrimary)
                    }
                }
            }
            .sheet(isPresented: $showProfile) {
                ProfileView()
            }
        }
        .task {
            if let userId = env.session.userId {
                await env.entitlements.identify(userId: userId)
            }
        }
        .tint(Theme.accent)
    }

    private var hero: some View {
        VStack(spacing: 10) {
            Text("Найди книгу,\nкоторая попадёт в тебя")
                .font(.system(size: 28, weight: .bold, design: .serif))
                .multilineTextAlignment(.center)
            Text("Короткий тест — и три книги с объяснением, что именно ты из них извлечёшь.")
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 16)
    }

    private var statusCard: some View {
        HStack(spacing: 14) {
            Image(systemName: env.entitlements.isPro ? "crown.fill" : "sparkles")
                .foregroundStyle(Theme.accent)
                .font(.title2)
            VStack(alignment: .leading, spacing: 2) {
                Text(env.entitlements.isPro ? "Подписка активна" : "Бесплатный тариф")
                    .fontWeight(.semibold)
                Text(env.entitlements.isPro
                     ? "Безлимитные прохождения теста"
                     : "Доступно \(AppConfig.freeQuizLimit) прохождения теста")
                    .font(.footnote)
                    .foregroundStyle(Theme.textSecondary)
            }
            Spacer()
        }
        .krafCard()
        .foregroundStyle(Theme.textPrimary)
    }

    private var startCard: some View {
        NavigationLink {
            QuizView()
        } label: {
            HStack {
                Text("Начать подбор")
                    .fontWeight(.semibold)
                Spacer()
                Image(systemName: "arrow.right")
            }
            .padding(18)
            .frame(maxWidth: .infinity)
            .background(Theme.accent, in: RoundedRectangle(cornerRadius: Theme.corner))
            .foregroundStyle(.white)
        }
    }

    private var howItWorks: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Как это работает")
                .font(.headline)
                .foregroundStyle(Theme.textPrimary)
            stepRow(number: 1, text: "Отвечаешь на вопросы о себе и предпочтениях")
            stepRow(number: 2, text: "Алгоритм строит твой читательский профиль")
            stepRow(number: 3, text: "Получаешь топ-3 книги с личными комментариями")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .krafCard()
    }

    private func stepRow(number: Int, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.footnote.weight(.bold))
                .frame(width: 26, height: 26)
                .background(Theme.accentSoft, in: Circle())
                .foregroundStyle(Theme.accent)
            Text(text)
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
            Spacer()
        }
    }
}
