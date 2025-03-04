import Foundation

struct Option: Hashable {
    let id: String
    let word: String
    let meaning: String
    
    init(id: String, word: String, meaning: String) {
        self.id = id
        self.word = word
        self.meaning = meaning
    }
}
