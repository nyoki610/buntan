import Foundation

enum CustomText {
    
    // TODO: replace boldSentence(card: Card, ...) with boldSentence(card: LearnCard, ...)
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
    
    static func boldSentence(card: LearnCard, size: CGFloat, isUnderlined: Bool) -> AttributedString {
        
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

    
    static func replaceSubstring(in originalString: String, targetSubstring: String) -> String {

        /// 置き換える対象の文字列が空の場合は、元の文字列をそのまま返す
        guard !targetSubstring.isEmpty else { return originalString }

        /// 元の文字列に対象の文字列が含まれているか確認
        guard let range = originalString.range(of: targetSubstring) else {
            /// 含まれていない場合は元の文字列をそのまま返す
            return originalString
        }

        /// 置き換える「_」の数を計算（対象文字列の長さと同じ数だけ）
        let replacement = String(repeating: "_", count: targetSubstring.count)

        /// 指定された範囲を「_」で置き換える
        var processedString = originalString
        processedString.replaceSubrange(range, with: replacement)

        return processedString
    }
}
