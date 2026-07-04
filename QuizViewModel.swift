import Foundation
import Observation

@MainActor
@Observable
final class QuizViewModel {
    enum Outcome: Equatable {
        case results(RecommendationResponse)
        case paywall
    }

    let questions = QuizCatalog.questions
    var currentIndex = 0
    var answers: [String: QuizAnswerValue] = [:]

    var isSubmitting = false
    var errorMessage: String?
    var outcome: Outcome?

    private let service = RecommendationService()

    var currentQuestion: QuizQuestion { questions[currentIndex] }
    var progress: Double { Double(currentIndex + 1) / Double(questions.count) }
    var isLastQuestion: Bool { currentIndex == questions.count - 1 }

    var isCurrentAnswered: Bool {
        answers[currentQuestion.id]?.isAnswered ?? false
    }

    // MARK: Answering

    func setScale(_ value: Int) {
        answers[currentQuestion.id] = .scale(value)
    }

    func setSingle(_ optionId: String) {
        answers[currentQuestion.id] = .single(optionId)
    }

    func toggleMulti(_ optionId: String, maxSelections: Int?) {
        var current: [String]
        if case let .multi(arr) = answers[currentQuestion.id] {
            current = arr
        } else {
            current = []
        }
        if let idx = current.firstIndex(of: optionId) {
            current.remove(at: idx)
        } else {
            if let max = maxSelections, current.count >= max { return }
            current.append(optionId)
        }
        answers[currentQuestion.id] = .multi(current)
    }

    func isSelected(_ optionId: String) -> Bool {
        switch answers[currentQuestion.id] {
        case .single(let s): return s == optionId
        case .multi(let arr): return arr.contains(optionId)
        default: return false
        }
    }

    func scaleValue() -> Int? {
        if case let .scale(v) = answers[currentQuestion.id] { return v }
        return nil
    }

    // MARK: Navigation

    func next() {
        guard isCurrentAnswered else { return }
        if currentIndex < questions.count - 1 {
            currentIndex += 1
        }
    }

    func back() {
        if currentIndex > 0 { currentIndex -= 1 }
    }

    // MARK: Submission

    func submit() async {
        guard isCurrentAnswered else { return }
        isSubmitting = true
        errorMessage = nil
        defer { isSubmitting = false }

        Telemetry.breadcrumb("quiz submitted", category: "quiz")
        do {
            let submission = buildSubmission()
            let result = try await service.recommend(submission: submission)
            switch result {
            case .success(let response):
                Telemetry.breadcrumb("recommendations received", category: "quiz")
                outcome = .results(response)
            case .paywallRequired:
                Telemetry.breadcrumb("paywall required", category: "quiz")
                outcome = .paywall
            }
        } catch {
            Telemetry.capture(error, context: ["stage": "recommend"])
            errorMessage = (error as? LocalizedError)?.errorDescription
                ?? "Не удалось получить рекомендации. Попробуйте ещё раз."
        }
    }

    private func buildSubmission() -> QuizSubmission {
        var payload: [String: QuizSubmission.AnswerPayload] = [:]
        for question in questions {
            guard let answer = answers[question.id] else { continue }
            let value: AnyEncodableValue
            switch answer {
            case .scale(let v): value = .int(v)
            case .single(let s): value = .string(labelFor(question: question, optionId: s))
            case .multi(let arr):
                value = .stringArray(arr.map { labelFor(question: question, optionId: $0) })
            }
            payload[question.id] = .init(
                section: question.section,
                prompt: question.prompt,
                value: value
            )
        }
        return QuizSubmission(answers: payload)
    }

    /// Convert option ids to human labels so the LLM gets meaningful text.
    private func labelFor(question: QuizQuestion, optionId: String) -> String {
        switch question.kind {
        case .singleChoice(let options), .multiChoice(let options, _):
            return options.first { $0.id == optionId }?.label ?? optionId
        case .scale:
            return optionId
        }
    }
}
