import Foundation


extension CheckLearnViewViewModelProtocol {
    
    func checkLearnSaveAction(
        pathHandler: CheckViewPathHandler,
        loadingSharedData: LoadingSharedData,
        checkUserInput: CheckUserInput
    ) {

        loadingSharedData.startLoading(.save)
        
        /// realm にテストの結果を保存
        let checkRecord = CheckRecord(UUID().uuidString,
                                      checkUserInput.selectedGrade,
                                      Date(),
                                      rightCardsIndexList.count,
                                      estimatedScore)

        let _ = CheckRecordRealmAPI.uploadCheckRecord(checkRecord: checkRecord)
        
        loadingSharedData.finishLoading {
            pathHandler.transitionScreen(to: .checkResult)
        }
    }
}
