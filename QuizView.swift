import SwiftUI

struct QuizView: View {
    @Environment(AppEnvironment.self) private var env
    @State private var viewModel = QuizViewModel()
    @State private var showPaywall = false

    var body: some View {
        VStack(spacing: 0) {
            progressBar

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text(viewModel.currentQuestion.section.uppercased())
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.accent)

                    Text(viewModel.currentQuestion.prompt)
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(Theme.textPrimary)

                    answerControls

                    if let error = viewModel.errorMessage {
                        Text(error).font(.footnote).foregroundStyle(.red)
                    }
                }
                .padding(24)
            }

            controls
        }
        .krafBackground()
        .navigationTitle("Подбор")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(item: resultsBinding) { response in
            ResultsView(response: response)
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
        .onChange(of: viewModel.outcome) { _, outcome in
            if outcome == .paywall { showPaywall = true }
        }
    }

    // Map outcome -> optional results response for navigation.
    private var resultsBinding: Binding<RecommendationResponse?> {
        Binding(
            get: {
                if case let .results(response) = viewModel.outcome { return response }
                return nil
            },
            set: { newValue in
                if newValue == nil { viewModel.outcome = nil }
            }
        )
    }

    private var progressBar: some View {
        ProgressView(value: viewModel.progress)
            .tint(Theme.accent)
            .padding(.horizontal, 24)
            .padding(.top, 8)
    }

    @ViewBuilder
    private var answerControls: some View {
        switch viewModel.currentQuestion.kind {
        case let .scale(minV, maxV, minLabel, maxLabel):
            ScaleControl(
                range: minV...maxV,
                minLabel: minLabel,
                maxLabel: maxLabel,
                selected: viewModel.scaleValue(),
                onSelect: viewModel.setScale
            )
        case let .singleChoice(options):
            VStack(spacing: 12) {
                ForEach(options) { option in
                    ChoiceRow(
                        label: option.label,
                        isSelected: viewModel.isSelected(option.id),
                        multiple: false
                    ) {
                        viewModel.setSingle(option.id)
                    }
                }
            }
        case let .multiChoice(options, maxSelections):
            VStack(spacing: 12) {
                if let max = maxSelections {
                    Text("Можно выбрать до \(max)")
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                ForEach(options) { option in
                    ChoiceRow(
                        label: option.label,
                        isSelected: viewModel.isSelected(option.id),
                        multiple: true
                    ) {
                        viewModel.toggleMulti(option.id, maxSelections: maxSelections)
                    }
                }
            }
        }
    }

    private var controls: some View {
        HStack(spacing: 12) {
            if viewModel.currentIndex > 0 {
                Button {
                    viewModel.back()
                } label: {
                    Text("Назад")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 12))
                }
                .foregroundStyle(Theme.textPrimary)
            }

            Button {
                if viewModel.isLastQuestion {
                    Task { await viewModel.submit() }
                } else {
                    viewModel.next()
                }
            } label: {
                ZStack {
                    if viewModel.isSubmitting {
                        ProgressView().tint(.white)
                    } else {
                        Text(viewModel.isLastQuestion ? "Подобрать книги" : "Далее")
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Theme.accent, in: RoundedRectangle(cornerRadius: 12))
            }
            .foregroundStyle(.white)
            .disabled(!viewModel.isCurrentAnswered || viewModel.isSubmitting)
            .opacity(viewModel.isCurrentAnswered ? 1 : 0.5)
        }
        .padding(24)
    }
}

// MARK: - Controls

private struct ScaleControl: View {
    let range: ClosedRange<Int>
    let minLabel: String
    let maxLabel: String
    let selected: Int?
    let onSelect: (Int) -> Void

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 10) {
                ForEach(Array(range), id: \.self) { value in
                    Button {
                        onSelect(value)
                    } label: {
                        Text("\(value)")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(
                                selected == value ? Theme.accent : Color.white.opacity(0.06),
                                in: RoundedRectangle(cornerRadius: 12)
                            )
                            .foregroundStyle(selected == value ? .white : Theme.textPrimary)
                    }
                }
            }
            HStack {
                Text(minLabel)
                Spacer()
                Text(maxLabel)
            }
            .font(.caption)
            .foregroundStyle(Theme.textSecondary)
        }
    }
}

private struct ChoiceRow: View {
    let label: String
    let isSelected: Bool
    let multiple: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(label)
                    .foregroundStyle(Theme.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: indicatorName)
                    .foregroundStyle(isSelected ? Theme.accent : Theme.textSecondary)
            }
            .padding(16)
            .background(
                isSelected ? Theme.accentSoft : Color.white.opacity(0.06),
                in: RoundedRectangle(cornerRadius: 12)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Theme.accent : Color.clear, lineWidth: 1)
            )
        }
    }

    private var indicatorName: String {
        if multiple {
            return isSelected ? "checkmark.square.fill" : "square"
        } else {
            return isSelected ? "largecircle.fill.circle" : "circle"
        }
    }
}
