import Foundation


extension CheckLearnViewViewModelProtocol {
    
    internal func checkLearnSaveAction(
        pathHandler: CheckViewPathHandler,
        loadingSharedData: LoadingSharedData,
        checkUserInput: CheckUserInput
    ) {

        loadingSharedData.startLoading(.save)
        
        let estimatedScore = calcEstimatedScore(selectedGrade: checkUserInput.selectedGrade)
        
        /// realm にテストの結果を保存
        let checkRecord = CheckRecord(
            id: UUID().uuidString,
            grade: checkUserInput.selectedGrade,
            date: Date(),
            correctCount: rightCardsIndexList.count,
            estimatedCount: estimatedScore
        )

        let _ = CheckRecordRealmAPI.uploadCheckRecord(checkRecord: checkRecord)
        
        loadingSharedData.finishLoading {
            pathHandler.transitionScreen(to: .checkResult(
                self.cards, self.rightCardsIndexList, estimatedScore
            ))
        }
    }
    
    private func calcEstimatedScore(selectedGrade: EikenGrade) -> Int {
        
        var fullScore: Double = 0
        var score: Double = 0
        
        for (index, card) in cards.enumerated() {
            
            let cardScore = card.infoList.reduce(0.0) { $0 + ($1.isAnswer ? 3 : 1) }
            
            fullScore += cardScore
            
            if rightCardsIndexList.contains(index) {
                score += cardScore
            }
        }
        return Int((score / fullScore) * selectedGrade.questionCount.double)
    }
}
