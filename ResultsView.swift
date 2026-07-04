import SwiftUI

struct ResultsView: View {
    let response: RecommendationResponse
    @Environment(AppEnvironment.self) private var env

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header
                profileSummary
                ForEach(response.recommendations.sorted { $0.rank < $1.rank }) { rec in
                    BookCardView(recommendation: rec)
                }
                if let remaining = response.remainingFree, !response.isPro {
                    remainingFooter(remaining)
                }
            }
            .padding(24)
        }
        .krafBackground()
        .navigationTitle("Твои книги")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Топ-3 для тебя")
                .font(.system(size: 26, weight: .bold, design: .serif))
                .foregroundStyle(Theme.textPrimary)
            Text("Подобрано по твоему читательскому профилю")
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
        }
        .padding(.top, 8)
    }

    private var profileSummary: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Твой профиль", systemImage: "person.text.rectangle")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Theme.accent)
            Text(response.readerProfile.summary)
                .font(.subheadline)
                .foregroundStyle(Theme.textPrimary.opacity(0.9))
                .fixedSize(horizontal: false, vertical: true)
            if !response.readerProfile.preferredGenres.isEmpty {
                tagRow(response.readerProfile.preferredGenres)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .krafCard()
    }

    private func tagRow(_ tags: [String]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.white.opacity(0.06), in: Capsule())
                        .foregroundStyle(Theme.textSecondary)
                }
            }
        }
    }

    private func remainingFooter(_ remaining: Int) -> some View {
        VStack(spacing: 4) {
            Text(remaining > 0
                 ? "Осталось бесплатных прохождений: \(remaining)"
                 : "Бесплатные прохождения закончились")
                .font(.footnote)
                .foregroundStyle(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
    }
}
