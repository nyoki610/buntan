import Foundation


extension CheckLearnViewViewModelProtocol {
    
    internal func checkLearnSaveAction(
        navigator: CheckNavigator,
        loadingManager: LoadingManager,
        checkUserInput: CheckUserInput
    ) async {

        await loadingManager.startLoading(.save)
        
        let estimatedScore = calcEstimatedScore(selectedGrade: checkUserInput.selectedGrade)
        
        /// realm にテストの結果を保存
        let checkRecord = CheckRecord(
            id: UUID().uuidString,
            grade: checkUserInput.selectedGrade,
            date: Date(),
            correctCount: rightCardsIndexList.count,
            estimatedCount: estimatedScore
        )

        try? checkRecordUseCase.uploadCheckRecord(checkRecord: checkRecord)
        
        await loadingManager.finishLoading()
        
        navigator.push(.checkResult(self.cards, self.rightCardsIndexList, estimatedScore))
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
