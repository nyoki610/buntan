import Foundation

enum CustomText {
    
    /// card.sentence の card.startPosition から card.endPosition までを太字にする関数
    static func boldSentence(card: Card, size: CGFloat, isUnderlined: Bool) -> AttributedString {
        
        let sentence = card.sentence
        let startPosition = card.startPosition
        let endPosition = card.endPosition
        
        var attributedString = AttributedString(sentence)
        
        guard startPosition < endPosition, startPosition >= 0, endPosition <= sentence.count else {
            return attributedString
        }

        let startIndex = sentence.index(sentence.startIndex, offsetBy: startPosition)
        let endIndex = sentence.index(sentence.startIndex, offsetBy: endPosition)
        
        if let range = attributedString.range(of: Substring(sentence[startIndex...endIndex])) {
            /// Text(AttributedString) に .font(.system(size: )) を適用しても, AttributedString,font が優先される
            var attributes = AttributeContainer()
            attributes.font = .system(size: size, weight: .bold)
            attributedString[range].setAttributes(attributes)
            if isUnderlined {
                attributedString[range].underlineStyle = .single
            }
            
        } else { return AttributedString("") }
        
        return attributedString
    }
    
    /// card.sentence の card.startPosition から card.endPosition までをアンダースコアに置き換える関数
    static func replaceAnswer(card: Card, showInitial: Bool) -> String {
        
        let sentence = card.sentence
        let startPosition = card.startPosition + (showInitial ? 1 : 0)
        let endPosition = card.endPosition
        
        /// 二文字の単語のイニシャル非表示の場合は statrPosition = endPosition となる
        guard startPosition <= endPosition, startPosition >= 0, endPosition <= sentence.count else { return sentence }

        var processedSentence = sentence
        let startIndex = sentence.index(sentence.startIndex, offsetBy: startPosition)
        let endIndex = sentence.index(sentence.startIndex, offsetBy: endPosition)
        let range = startIndex...endIndex

        processedSentence.replaceSubrange(range, with: String(repeating: "_", count: endPosition - startPosition + 1))
        return processedSentence
    }
}
