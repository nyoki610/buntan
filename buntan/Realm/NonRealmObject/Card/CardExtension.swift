import Foundation

extension Card {
    
    func posPrefix(_ text: String) -> String { "【\(pos.jaLabel)】 \(text)" }
    
    var wordWithPhrase: String { word + (phrase.isEmpty ? "" : " \(phrase.parentheses())") }
    
    var customPhrase: String { phrase.isEmpty ? "" : "\(phrase) で".parentheses() }
    
    var customMeaning: String { posPrefix(customPhrase + meaning) }
    
    var priority: Int {
        infoList.reduce(0) { $0 + ($1.isAnswer ? 10 : 1) }
    }
    
    var isSentenceExist: Bool {
        !sentence.isEmpty && !translation.isEmpty
    }
}


extension Card {
    
    var clozeAnswer: String? {
        
        guard isSentenceAvailable else { return nil }
        
        let startIndex = sentence.index(sentence.startIndex, offsetBy: startPosition)
        let endIndex = sentence.index(sentence.startIndex, offsetBy: endPosition)
        
        return String(sentence[startIndex...endIndex])
    }
    
    private var isSentenceAvailable: Bool {
        
        /// 例文・訳が含まれていない場合
        guard sentence != "" && translation != "" else {
            return false
        }
        
        /// startPosition, endPosition の値が無効である場合
        guard 0 <= startPosition,
              startPosition < endPosition,
              endPosition < sentence.count else {
            return false
        }
        
        return true
    }
}
