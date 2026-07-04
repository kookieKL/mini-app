import SwiftUI

struct BookCardView: View {
    let recommendation: Recommendation

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 12) {
                rankBadge
                VStack(alignment: .leading, spacing: 4) {
                    Text(recommendation.book.title)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(Theme.textPrimary)
                    Text(recommendation.book.author)
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                    if let genre = recommendation.book.genre {
                        Text(genre)
                            .font(.caption.weight(.medium))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Theme.accentSoft, in: Capsule())
                            .foregroundStyle(Theme.accent)
                            .padding(.top, 2)
                    }
                }
                Spacer()
            }

            VStack(alignment: .leading, spacing: 6) {
                Label("Что ты из неё извлечёшь", systemImage: "sparkles")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.accent)
                Text(recommendation.profitComment)
                    .font(.subheadline)
                    .foregroundStyle(Theme.textPrimary.opacity(0.9))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .krafCard()
    }

    private var rankBadge: some View {
        Text("\(recommendation.rank)")
            .font(.headline.weight(.bold))
            .frame(width: 36, height: 36)
            .background(Theme.accent, in: Circle())
            .foregroundStyle(.white)
    }
}
