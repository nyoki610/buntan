import SwiftUI

protocol LearnViewProtocol: View {
    
    var realmService: RealmService { get }
    var loadingSharedData: LoadingSharedData { get }
    var bookSharedData: BookSharedData { get }
    var checkSharedData: CheckSharedData { get }
    var learnManager: LearnManager { get }
    var alertSharedData: AlertSharedData { get }
    
    func saveAction(isBookView: Bool)
}

extension LearnViewProtocol {
    
    var cards: [Card] { learnManager.cards.map { $0 } }
    var topCardIndex: Int { learnManager.topCardIndex }
    var topCard: Card { topCardIndex < cards.count ?  cards[topCardIndex] : EmptyModel.card }
    
    var rightCardsIndexList: [Int] { learnManager.rightCardsIndexList }
    var leftCardsIndexList: [Int] { learnManager.leftCardsIndexList }
    
    var nextCardExist: Bool { topCardIndex < cards.count - 1 }
    
    func saveAction(isBookView: Bool) {
        
        learnManager.isKeyboardActive = false
        
        let cardsCount = learnManager.leftCardsIndexList.count + learnManager.rightCardsIndexList.count
        let isFinished = (cardsCount == learnManager.cards.count)
        
        if isBookView {
            
            guard cardsCount != 0 else {
                bookSharedData.path.removeLast()
                return
            }

            loadingSharedData.startLoading(.save)

            /// ensure loading screen rendering by delaying the next process
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                guard let updatedBooksList = realmService.saveProgress(learnManager,
                                                                       bookSharedData.selectedGrade,
                                                                       bookSharedData.selectedBook.bookType) else {
                    loadingSharedData.finishLoading {
                        bookSharedData.path.removeLast()
                    }
                    return
                }
                bookSharedData.setupBooksList(updatedBooksList)
                
                let learnRecord = LearnRecord(UUID().uuidString, Date(),
                                              cardsCount)
                realmService.synchronizeRecord(learnRecord: learnRecord)

                loadingSharedData.finishLoading {
                    if !isFinished {
                        bookSharedData.path.removeLast()
                    } else {
                        bookSharedData.path.append(.learnResult)
                    }
                }
            }
        } else {
            
            if !isFinished {
                
                alertSharedData.showSelectiveAlert("テストを中断しますか？",
                                                   "",
                                                   "終了",
                                                   .defaultButton) {
                                                       checkSharedData.path.removeLast()
                                                   }
                
            } else {
                
                loadingSharedData.startLoading(.save)
                let checkRecord = CheckRecord(UUID().uuidString,
                                              checkSharedData.selectedGrade,
                                              Date(),
                                              learnManager.rightCardsIndexList.count,
                                              checkSharedData.estimatedScore(learnManager))

                realmService.synchronizeRecord(checkRecord: checkRecord)
                loadingSharedData.finishLoading {
                    checkSharedData.path.append(.checkResult)
                }
            }
        }
    }
}
