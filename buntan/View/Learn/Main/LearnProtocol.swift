import SwiftUI


/// 学習モードで使用する property を持つ Protocol
/// 以下の View で使用
///     - SwipeView()
///     - SelectView()
///     - TypeView()
///     - LearnHeader()
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
    
    /// EnvironmentObject を使用した computedPropert
    /// ------------------------------
    var cards: [Card] { learnManager.cards.map { $0 } }
    var topCardIndex: Int { learnManager.topCardIndex }
    var topCard: Card { topCardIndex < cards.count ?  cards[topCardIndex] : EmptyModel.card }
    
    var rightCardsIndexList: [Int] { learnManager.rightCardsIndexList }
    var leftCardsIndexList: [Int] { learnManager.leftCardsIndexList }
    
    var nextCardExist: Bool { topCardIndex < cards.count - 1 }
    /// ------------------------------
    
    func saveAction(isBookView: Bool) {
        
        /// Keyboard を非表示 (for TypeView())
        learnManager.isKeyboardActive = false
        
        let cardsCount = learnManager.leftCardsIndexList.count + learnManager.rightCardsIndexList.count
        
        /// 「学習を最後まで進めてから save しようとしているか」を判断
        let isFinished = (cardsCount == learnManager.cards.count)
        
        /// 学習モードは BookView と CheckView の両方からアクセスできる -> それぞれで処理を分ける
        
        /// BookView の場合の処理
        if isBookView {
            
            /// １単語も学習していない場合は save せずに exit
            guard cardsCount != 0 else {
                bookSharedData.path.removeLast()
                return
            }

            /// loading を開始
            loadingSharedData.startLoading(.save)

            /// ensure loading screen rendering by delaying the next process
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                
                /// 学習内容を realm に保存
                guard let updatedBooksList = realmService.saveProgress(learnManager,
                                                                       bookSharedData.selectedGrade,
                                                                       bookSharedData.selectedBook.bookType) else {
                    loadingSharedData.finishLoading {
                        bookSharedData.path.removeLast()
                    }
                    return
                }
                /// bookSharedData.bookList を再初期化
                bookSharedData.setupBooksList(updatedBooksList)
                
                /// 学習量の記録を保存
                let learnRecord = LearnRecord(UUID().uuidString, Date(),
                                              cardsCount)
                realmService.synchronizeRecord(learnRecord: learnRecord)

                /// loading を終了して画面遷移
                loadingSharedData.finishLoading {
                    if !isFinished {
                        bookSharedData.path.removeLast()
                    } else {
                        bookSharedData.path.append(.learnResult)
                    }
                }
            }
        
        /// CheckView の場合の処理
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
                
                /// realm にテストの結果を保存
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
