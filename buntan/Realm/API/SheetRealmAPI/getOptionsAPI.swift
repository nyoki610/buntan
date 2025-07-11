import Foundation


extension SheetRealmAPI {
    
    /// 引数として受け取った cards に対応する option の二次元配列を返す
    static func getOptions(
        eikenGrade: EikenGrade,
        cards: [Card],
        containFifthOption: Bool
    ) -> [[Option]]? {
                
        guard let targetGradeCards = SheetRealmCruds
            .getSheetByGrade(eikenGrade: eikenGrade)?
            .cardList else { return nil }
        
        var nounOptions: [Option] = []
        var verbOptions: [Option] = []
        var adjectiveOptions: [Option] = []
        var adverbOptions: [Option] = []
        var idiomOptions: [Option] = []
        
        targetGradeCards.forEach { card in
            switch card.pos {
            case .noun: nounOptions.append(card.convertToOption())
            case .verb: verbOptions.append(card.convertToOption())
            case .adjective: adjectiveOptions.append(card.convertToOption())
            case .adverb: adverbOptions.append(card.convertToOption())
            case .idiom: idiomOptions.append(card.convertToOption())
            }
        }
        
        let optionsRef = [
            nounOptions,
            verbOptions,
            adjectiveOptions,
            adverbOptions,
            idiomOptions
        ]
        
        let options = cards.map { card in
            
            var optionRef: [Option] {
                switch card.pos {
                case .noun, .verb, .adjective, .adverb: optionsRef[card.pos.rawValue - 1]
                case .idiom: optionsRef[4]
                }
            }
            
            let filteredRef = optionRef.filter { $0.word != card.word }
            /// ランダムなインデックスを選ぶ実装にした方が良い？
            let randomOptions = filteredRef.shuffled().prefix(containFifthOption ? 4 : 3)
            return Array(Set([card.convertToOption()] + randomOptions)).shuffled()
        }
        
        return options
    }
}
