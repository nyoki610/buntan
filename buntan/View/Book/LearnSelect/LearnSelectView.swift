import SwiftUI


struct LearnSelectView: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType: DeviceType
    
    @EnvironmentObject var realmService: RealmService
    @EnvironmentObject var bookSharedData: BookSharedData
    @EnvironmentObject var alertSharedData: AlertSharedData
    @EnvironmentObject var loadingSharedData: LoadingSharedData
    @EnvironmentObject var learnManager: LearnManager
    
    @ObservedObject private var pathHandler: PathHandler
    let cardsContainer: CardsContainer
    
    init(pathHandler: PathHandler, cardsContainer: CardsContainer) {
        self.pathHandler = pathHandler
        self.cardsContainer = cardsContainer
    }

    var body: some View {
            
            ZStack {
                
                VStack {
                    
                    let title = bookSharedData.selectedGrade.title + "   " + bookSharedData.selectedBookConfig.title + "   " +  bookSharedData.selectedSectionTitle

                    Header(pathHandler: pathHandler,
                           title: title)
                    
                    subButtonView
                    
                    Spacer()
                    
                    progressView
                    
                    Spacer()
                    
                    selectView
                        .frame(width: responsiveSize(280, 360))
                    
                    Spacer()
                    
                    StartButton(label: "学習を開始 →",
                                color: Orange.defaultOrange) {
                        
                        guard let options = bookSharedData.selectedGrade.setupOptions(
                            booksDict: realmService.booksDict,
                            cards: cardsContainer.getCardsByLearnRange(learnRange: bookSharedData.selectedRange),
                            isBookView: true
                        ) else { return }
                        
                        bookSharedData.options = options
                        
                        let cards = cardsContainer.getCardsByLearnRange(learnRange: bookSharedData.selectedRange)
                        
                        learnManager.setupLearn(cards, options)
                        pathHandler.transitionScreen(
                            to: bookSharedData.selectedMode.viewName(
                                cards: cards,
                                isBookView: true
                            )
                        )
                    }

                    Spacer()
                }
            }
            .background(CustomColor.background)
            .navigationBarBackButtonHidden(true)
    }
    
    @ViewBuilder
    var progressView: some View {
        
        HStack {
            
            LearnSelectCircle(
                
                firstCircle: .init(
                    value: cardsContainer.learnedCount + cardsContainer.learningCount,
                    color: RoyalBlue.semiOpaque
                ),
                
                secondCircle: .init(
                    value: cardsContainer.learnedCount,
                    color: Orange.defaultOrange
                ),
                
                size: responsiveSize(140, 200),
                maxValue: cardsContainer.allCount
            )
            
            Spacer()
            
            VStack(alignment: .leading) {
                Spacer()
                Spacer()
                Spacer()
                circleAnnotation(label: "完了", color: Orange.defaultOrange)
                circleAnnotation(label: "学習中", color: RoyalBlue.semiOpaque)
                Spacer()
            }
            .frame(height: 140)
        }
        .frame(width: responsiveSize(300, 400))
    }
    
    @ViewBuilder
    private func circleAnnotation(label: String, color: Color) -> some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: responsiveSize(16, 20), height: responsiveSize(16, 20))
            Text(label)
                .fontWeight(.medium)
                .font(.system(size: responsiveSize(16, 20)))
        }
    }
    
    @ViewBuilder
    private var subButtonView: some View {
        
        HStack {
            /// 「未学習の単語数」!=「全単語数」の場合のみ表示
            if cardsContainer.notLearnedCount != cardsContainer.allCount {
                subButton(label: "リセット",
                          systemName: "arrow.clockwise",
                          color: .red) {
                    resetAction()
                }
            }
            Spacer()
            subButton(label: "単語一覧",
                      systemName: "info.circle.fill",
                      color: .blue) {
                pathHandler.transitionScreen(to: .book(.wordList(cardsContainer.allCards)))
            }
        }
        .frame(width: responsiveSize(300, 420))
        .font(.system(size: responsiveSize(14, 20)))
        .fontWeight(.bold)
    }

    
    @ViewBuilder
    private func subButton(label: String, systemName: String, color: Color, action: @escaping () -> Void) -> some View {
        
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: systemName)
                    .font(.system(size: responsiveSize(18, 22)))
                Text(label)
                    .fontWeight(.medium)
            }
            .foregroundStyle(color)
            .padding(.horizontal, 16)
            .padding(.vertical, 2)
            .background(.white)
            .cornerRadius(responsiveSize(12, 15))
            .shadow(color: .gray.opacity(0.8), radius: 2, x: 0, y: 2)
        }
    }
}

extension LearnSelectView {
    
    func resetAction() {
        
        alertSharedData.showSelectiveAlert(title: "現在の進捗を\nリセットしますか？",
                                           message: "",
                                           secondaryButtonLabel: "リセット",
                                           secondaryButtonType: .destructive) {
            loadingSharedData.startLoading(.process)
            
            /// ensure loading screen rendering by delaying the next process
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                
                guard let updatedBooksDict = realmService.resetProgress(
                    cardsContainer.allCards,
                    bookSharedData.selectedGrade,
                    bookSharedData.selectedBookConfig.bookCategory
                ) else {
                    return
                }
                
                realmService.booksDict = updatedBooksDict

                loadingSharedData.finishLoading {}
            }
        }
    }
}


extension LearnSelectView {
    
    func adjustSelectedRange() {
        
        bookSharedData.selectedRange = .notLearned
        
        if cardsContainer.notLearnedCount == 0 {
            bookSharedData.selectedRange = .learning
            
            if cardsContainer.learningCount == 0 {
                bookSharedData.selectedRange = .all
            }
        }
    }
}
