import Foundation

extension APIHandler {
    
    static func getLatestCards() async throws -> (firstGradeCards: [Card], preFirstGradeCards: [Card]) {

        guard let getLatestCardsPath = AppConfig.shared.getLatestCardsPath,
              let resultJson = await callAPI(path: getLatestCardsPath, method: .get) else {
            throw APIError.invalidJSON
        }
        
        guard let firstGradeJson = resultJson["first_grade_cards"] as? [[String: Any]],
              let preFirstGradeJson = resultJson["first_pre_grade_cards"] as? [[String: Any]] else {
            throw APIError.invalidJSON
        }

        let firstGradeData = try JSONSerialization.data(withJSONObject: firstGradeJson)
        let preFirstGradeData = try JSONSerialization.data(withJSONObject: preFirstGradeJson)

        do {
            let firstGradeCards = try JSONDecoder().decode([Card].self, from: firstGradeData)
            let preFirstGradeCards = try JSONDecoder().decode([Card].self, from: preFirstGradeData)
            return (firstGradeCards, preFirstGradeCards)
        } catch {
            print("Decoding error: \(error)")
            throw error
        }
    }
}
