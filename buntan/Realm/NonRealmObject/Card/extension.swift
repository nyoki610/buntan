import Foundation

extension Card {
    
    func posPrefix(_ text: String) -> String { "【\(pos.jaLabel)】 \(text)" }
    
    var wordWithPhrase: String { word + (phrase.isEmpty ? "" : " \(phrase.parentheses())") }
    
    var customPhrase: String { phrase.isEmpty ? "" : "\(phrase) で".parentheses() }
    
    var customMeaning: String { posPrefix(customPhrase + meaning) }
    
    var answer: String {
        
        guard
            startPosition >= 0,
            endPosition < sentence.count,
            startPosition <= endPosition else { return "" }
        
        let startIndex = sentence.index(sentence.startIndex, offsetBy: startPosition)
        let endIndex = sentence.index(sentence.startIndex, offsetBy: endPosition)
        
        return String(sentence[startIndex...endIndex])
    }
    
    var priority: Int {
        infoList.reduce(0) { $0 + ($1.isAnswer ? 10 : 1) }
    }
    
    var isSentenceExist: Bool {
        !sentence.isEmpty && !translation.isEmpty
    }
}
