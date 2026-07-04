import Foundation

/// Static questionnaire definition. Editing this file changes the test without
/// any backend changes — answers are forwarded as JSON to the recommend function.
enum QuizCatalog {
    static let questions: [QuizQuestion] = [
        // MARK: Личность (мини Big-Five)
        QuizQuestion(
            id: "openness",
            section: "Личность",
            prompt: "Меня тянет к новым идеям, абстрактным темам и непривычным взглядам.",
            kind: .scale(min: 1, max: 5, minLabel: "Совсем нет", maxLabel: "Очень")
        ),
        QuizQuestion(
            id: "conscientiousness",
            section: "Личность",
            prompt: "Я люблю структуру, планы и доводить дела до конца.",
            kind: .scale(min: 1, max: 5, minLabel: "Совсем нет", maxLabel: "Очень")
        ),
        QuizQuestion(
            id: "extraversion",
            section: "Личность",
            prompt: "Энергию мне даёт общение и активность вокруг.",
            kind: .scale(min: 1, max: 5, minLabel: "Совсем нет", maxLabel: "Очень")
        ),
        QuizQuestion(
            id: "agreeableness",
            section: "Личность",
            prompt: "Для меня важны гармония, эмпатия и забота о других.",
            kind: .scale(min: 1, max: 5, minLabel: "Совсем нет", maxLabel: "Очень")
        ),
        QuizQuestion(
            id: "neuroticism",
            section: "Личность",
            prompt: "Я часто переживаю, тревожусь или прокручиваю мысли в голове.",
            kind: .scale(min: 1, max: 5, minLabel: "Совсем нет", maxLabel: "Очень")
        ),

        // MARK: Жизненный фокус
        QuizQuestion(
            id: "current_focus",
            section: "Сейчас в фокусе",
            prompt: "Что для тебя сейчас важнее всего?",
            kind: .multiChoice(
                options: [
                    QuizOption(id: "career", label: "Карьера и рост"),
                    QuizOption(id: "calm", label: "Спокойствие и баланс"),
                    QuizOption(id: "relationships", label: "Отношения"),
                    QuizOption(id: "meaning", label: "Смысл и самопознание"),
                    QuizOption(id: "productivity", label: "Продуктивность и привычки"),
                    QuizOption(id: "money", label: "Финансы"),
                    QuizOption(id: "creativity", label: "Творчество"),
                    QuizOption(id: "health", label: "Здоровье и тело"),
                ],
                maxSelections: 3
            )
        ),
        QuizQuestion(
            id: "challenge",
            section: "Сейчас в фокусе",
            prompt: "Какой вызов тебе ближе всего прямо сейчас?",
            kind: .singleChoice(options: [
                QuizOption(id: "overwhelm", label: "Слишком много всего, теряю фокус"),
                QuizOption(id: "stuck", label: "Чувствую, что застрял(а)"),
                QuizOption(id: "anxiety", label: "Много тревоги и стресса"),
                QuizOption(id: "direction", label: "Не понимаю, куда двигаться"),
                QuizOption(id: "motivation", label: "Не хватает мотивации"),
                QuizOption(id: "growth", label: "Всё ок, хочу расти дальше"),
            ])
        ),

        // MARK: Предпочтения по жанрам
        QuizQuestion(
            id: "preferred_genres",
            section: "Предпочтения",
            prompt: "Какие жанры тебе интересны?",
            kind: .multiChoice(
                options: [
                    QuizOption(id: "philosophy", label: "Философия"),
                    QuizOption(id: "psychology", label: "Психология"),
                    QuizOption(id: "self_development", label: "Саморазвитие"),
                    QuizOption(id: "business", label: "Бизнес и карьера"),
                    QuizOption(id: "finance", label: "Финансы"),
                    QuizOption(id: "science", label: "Наука"),
                    QuizOption(id: "biography", label: "Биографии"),
                    QuizOption(id: "fiction", label: "Художественная литература"),
                    QuizOption(id: "mindfulness", label: "Осознанность"),
                    QuizOption(id: "creativity", label: "Творчество"),
                ],
                maxSelections: nil
            )
        ),

        // MARK: Стиль чтения
        QuizQuestion(
            id: "depth",
            section: "Стиль чтения",
            prompt: "Что тебе ближе?",
            kind: .singleChoice(options: [
                QuizOption(id: "practical", label: "Практичное — чтобы сразу применять"),
                QuizOption(id: "deep", label: "Глубокое — сложные идеи, над которыми думаешь"),
                QuizOption(id: "balanced", label: "Баланс теории и практики"),
            ])
        ),
        QuizQuestion(
            id: "length",
            section: "Стиль чтения",
            prompt: "Предпочитаемый объём книги?",
            kind: .singleChoice(options: [
                QuizOption(id: "short", label: "Короткая, читается за пару вечеров"),
                QuizOption(id: "any", label: "Не важно, главное — польза"),
                QuizOption(id: "long", label: "Готов(а) к большой, основательной книге"),
            ])
        ),
        QuizQuestion(
            id: "tone",
            section: "Стиль чтения",
            prompt: "Какой тон тебе заходит?",
            kind: .singleChoice(options: [
                QuizOption(id: "gentle", label: "Мягкий и вдохновляющий"),
                QuizOption(id: "direct", label: "Жёсткий и прямой"),
                QuizOption(id: "analytical", label: "Спокойный и аналитический"),
            ])
        ),
    ]
}
