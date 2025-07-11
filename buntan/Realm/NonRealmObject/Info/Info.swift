import Foundation
import RealmSwift

struct Info: Identifiable {
    let id: String
    let year: Int
    let time: Int
    let isAnswer: Bool
    
    init(id: String, year: Int, time: Int, isAnswer: Bool) {
        self.id = id
        self.year = year
        self.time = time
        self.isAnswer = isAnswer
    }
}
