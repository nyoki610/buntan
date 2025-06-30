import Foundation

enum Sample {
    
    static func createDate(_ year: Int, _ month: Int, _ day: Int) -> Date {
        let calendar = Calendar.current
        let components = DateComponents(year: year, month: month, day: day)
        return calendar.date(from: components) ?? Date()
    }
    
    static let learnRecords: [LearnRecord] = [
        .init(id: UUID().uuidString, date: createDate(2025, 1, 1), learnedCardCount: 100),
        .init(id: UUID().uuidString, date: createDate(2025, 1, 2), learnedCardCount: 100),
        .init(id: UUID().uuidString, date: createDate(2025, 1, 3), learnedCardCount: 100),
        .init(id: UUID().uuidString, date: createDate(2025, 1, 4), learnedCardCount: 100),
        .init(id: UUID().uuidString, date: createDate(2025, 1, 5), learnedCardCount: 20),
        .init(id: UUID().uuidString, date: createDate(2025, 1, 6), learnedCardCount: 30),
        .init(id: UUID().uuidString, date: createDate(2025, 1, 7), learnedCardCount: 60),
        .init(id: UUID().uuidString, date: createDate(2025, 1, 8), learnedCardCount: 20),
        .init(id: UUID().uuidString, date: createDate(2025, 1, 9), learnedCardCount: 40),
        .init(id: UUID().uuidString, date: createDate(2025, 1, 10), learnedCardCount: 70),
        .init(id: UUID().uuidString, date: createDate(2025, 1, 11), learnedCardCount: 80)
    ]
}
