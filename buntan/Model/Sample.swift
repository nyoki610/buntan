import Foundation

enum Sample {
    
    static func createDate(_ year: Int, _ month: Int, _ day: Int) -> Date {
        let calendar = Calendar.current
        let components = DateComponents(year: year, month: month, day: day)
        return calendar.date(from: components) ?? Date()
    }
    
    static let learnRecords: [LearnRecord] = [
        .init(UUID().uuidString, createDate(2025, 1, 1), 100),
        .init(UUID().uuidString, createDate(2025, 1, 2), 100),
        .init(UUID().uuidString, createDate(2025, 1, 3), 100),
        .init(UUID().uuidString, createDate(2025, 1, 4), 100),
        .init(UUID().uuidString, createDate(2025, 1, 5), 20),
        .init(UUID().uuidString, createDate(2025, 1, 6), 30),
        .init(UUID().uuidString, createDate(2025, 1, 7), 60),
        .init(UUID().uuidString, createDate(2025, 1, 8), 20),
        .init(UUID().uuidString, createDate(2025, 1, 9), 40),
        .init(UUID().uuidString, createDate(2025, 1, 10), 70),
        .init(UUID().uuidString, createDate(2025, 1, 11), 80)
    ]
}
