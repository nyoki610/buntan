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
//    var checkSharedData: CheckSharedData { get }
    var learnManager: LearnManager { get }
    var alertSharedData: AlertSharedData { get }
    var userInput: UserInput { get }
    
    var pathHandler: PathHandler { get set }
    
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
                pathHandler.backToPreviousScreen(count: 1)
                return
            }
            
            guard let bookUserInput = userInput as? BookUserInput else { return }

            /// loading を開始
            loadingSharedData.startLoading(.save)

            /// ensure loading screen rendering by delaying the next process
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                
                guard let selectedGrade = bookUserInput.selectedGrade,
                      let selectedBookCategory = bookUserInput.selectedBookCategory,
                      let selectedBookConfig = bookUserInput.selectedBookConfig,
                      let selectedSectionTitle = bookUserInput.selectedSectionTitle else { return }
                
                /// 学習内容を realm に保存
                guard realmService.saveProgress(learnManager,
                                                selectedGrade,
                                                selectedBookCategory) else {
                    loadingSharedData.finishLoading {
                        pathHandler.backToPreviousScreen(count: 1)
                    }
                    return
                }
                /// bookSharedData.bookList を再初期化
//                realmService.booksDict = updatedBooksDict
                
                /// 学習量の記録を保存
                let learnRecord = LearnRecord(UUID().uuidString, Date(),
                                              cardsCount)
                realmService.synchronizeRecord(learnRecord: learnRecord)
                
                let bookList = BookConfiguration.allCases
                    .filter { selectedBookCategory == $0.bookCategory }
                    .compactMap { realmService.booksDict[selectedGrade]?[$0] }
                let book = bookList.first { $0.config == selectedBookConfig }
                let section = book?.sections.first { $0.title == selectedSectionTitle }
                
                guard let section = section else { return }
                
                let cardsContainer = CardsContainer(cards: section.cards, bookCategory: selectedBookCategory)

                /// loading を終了して画面遷移
                loadingSharedData.finishLoading {
                    if !isFinished {
                        pathHandler.backToPreviousScreen(count: 2)
                        pathHandler.transitionScreen(to: .book(.learnSelect(cardsContainer)))
                    } else {
                        pathHandler.transitionScreen(to: .book(.learnResult(cardsContainer)))
                    }
                }
            }
        
        /// CheckView の場合の処理
        } else {
            
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

                realmService.synchronizeRecord(checkRecord: checkRecord)
                
                loadingSharedData.finishLoading {
                    pathHandler.transitionScreen(to: .check(.checkResult))
                }
            }
        }
    }
}
