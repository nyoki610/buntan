//import SwiftUI
//
//class LearnManager: ObservableObject {
//    
//    @Published var topCardIndex: Int = 0
//    @Published var animationController: Int = 0
//    @Published var rightCardsIndexList: [Int] = []
//    @Published var leftCardsIndexList: [Int] = []
//    var cards: [Card] = []
//    var options: [[Option]] = []
//    
//    @Published var showSettings: Bool = true
//    @Published var shouldShuffle: Bool = false
//    @Published var showInitial: Bool = false
//    @Published var showSentence: Bool = true
//    @Published var isKeyboardActive: Bool = false
//    
//    @Published var shouldReadOut: Bool = true
//    @Published var buttonDisabled: Bool = false
//    var avSpeaker: AVSpeaker?
//    
//    /// Learn開始前に必ず初期化
//    /// Learn終了後の初期化は無し
//    /// →ResultViewで各プロパティは使用可能
//    func setupLearn(_ cards: [Card], _ options: [[Option]]) -> Void {
//
//        topCardIndex = 0
//        animationController = 0
//        rightCardsIndexList = []
//        leftCardsIndexList = []
//        
//        self.cards = cards
//        self.options = options
//        
//        self.showSettings = true
//        
//        /// cards, optionsを連動させてシャッフル
//        if shouldShuffle {
//            
//            let indices = Array(0..<cards.count).shuffled()
//            
//            self.cards = indices.map { cards[$0] }
//            self.options = indices.map { options[$0] }
//        }
//        
//        /// 先頭のカードに例文が登録されていない場合、例文を非表示にする
//        if !self.cards[topCardIndex].isSentenceExist {
//            self.showSentence = false
//        }
//    }
//    
//    /// カードの音声読み上げ
////    func readOutTopCard(isButton: Bool = false) {
////        
////        guard (shouldReadOut || isButton) else { return }
////        
////        let (controllButton, withDelay) = (isButton, !isButton)
////        
////        guard topCardIndex < cards.count else { return }
////        let word = cards[topCardIndex].word
////        
////        avSpeaker?.readOutText(word,
////                               controllButton: controllButton,
////                               withDelay: withDelay)
////    }
//    
//    /// 一つ前のカードに戻る処理
//    func backButtonAction() -> Void {
//        
//        guard topCardIndex > 0 else { return }
//        
//        withAnimation(.easeOut(duration: 0.4)) {
//            self.topCardIndex -= 1
//        }
//        self.animationController -= 1
//        
//        if self.rightCardsIndexList.contains(self.topCardIndex) {
//            self.rightCardsIndexList.removeLast()
//        }
//        if self.leftCardsIndexList.contains(self.topCardIndex) {
//            self.leftCardsIndexList.removeLast()
//        }
//    }
//    
//    /// 表示中のカードを「完了 or 学習中」に振り分け
//    func addIndexToList(_ isCorrect: Bool) -> Void {
//        withAnimation(.easeOut(duration: 0.6)) {
//            if isCorrect {
//                rightCardsIndexList.append(topCardIndex)
//            } else {
//                leftCardsIndexList.append(topCardIndex)
//            }
//        }
//    }
//    
//    /// settingsを非表示にする(Swipe, Select, TypeでAnimationを共通にするため関数化)
//    func hideSettings() -> Void {
//        withAnimation(.easeOut(duration: 0.2)) {
//            self.showSettings = false
//        }
//    }
//}
//
//
//extension LearnManager {
//    
//    var estimatedScore: Int {
//        
//        var fullScore: Double = 0
//        var score: Double = 0
//        
//        for (index, card) in cards.enumerated() {
//            
//            let cardScore = card.infoList.reduce(0.0) { $0 + ($1.isAnswer ? 3 : 1) }
//            
//            fullScore += cardScore
//            
//            if rightCardsIndexList.contains(index) {
//                score += cardScore
//            }
//        }
//        return Int((score / fullScore) * EikenGrade.first.questionCount.double)
//    }
//}
