import Foundation


protocol CheckLearnViewProtocol: _LearnViewProtocol {
    var userDefaultHandler: LearnUserDefaultHandler { get }
    var learnManager: CheckLearnManager { get }
    var loadingSharedData: LoadingSharedData { get }
    var alertSharedData: AlertSharedData { get }
    var userInput: UserInput { get }
}


extension CheckLearnViewProtocol {
    
    func saveAction() {
        
        let cardsCount = learnManager.leftCardsIndexList.count + learnManager.rightCardsIndexList.count
        
        /// 「学習を最後まで進めてから save しようとしているか」を判断
        let isFinished = (cardsCount == learnManager.cards.count)
        
        
        guard let checkUserInput = userInput as? CheckUserInput else { return }

        if !isFinished {
            alertSharedData.showSelectiveAlert(title: "テストを中断しますか？",
                                               message: "",
                                               secondaryButtonLabel: "終了",
                                               secondaryButtonType: .defaultButton) {
                pathHandler.backToPreviousScreen(count: 1)
            }
            
        } else {
            
            loadingSharedData.startLoading(.save)
            
            /// realm にテストの結果を保存
            let checkRecord = CheckRecord(UUID().uuidString,
                                          checkUserInput.selectedGrade,
                                          Date(),
                                          learnManager.rightCardsIndexList.count,
                                          learnManager.estimatedScore)

            let _ = CheckRecordRealmAPI.uploadCheckRecord(checkRecord: checkRecord)
            
            loadingSharedData.finishLoading {
                pathHandler.transitionScreen(to: .check(.checkResult))
            }
        }
    }
}
