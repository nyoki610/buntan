import SwiftUI


struct LearnSelectView: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType: DeviceType
    
    @EnvironmentObject var alertSharedData: AlertSharedData
    @EnvironmentObject var loadingSharedData: LoadingSharedData
    
    @ObservedObject private var pathHandler: BookViewPathHandler
    @ObservedObject var userInput: BookUserInput
    
    @StateObject var viewModel: LearnSelectViewViewModel
    
    init(
        pathHandler: BookViewPathHandler,
        userInput: BookUserInput,
        cardsContainer: CardsContainer
    ) {
        self.pathHandler = pathHandler
        self.userInput = userInput
        self._viewModel = StateObject(
            wrappedValue: LearnSelectViewViewModel(cardsContainer: cardsContainer)
        )
    }

    private var headerTitle: String {
        var title: String = ""
        title += userInput.selectedGrade?.title ?? ""
        title += "   "
        title += userInput.selectedBookConfig?.title ?? ""
        title += userInput.selectedSectionTitle ?? ""
        return title
    }

    var body: some View {
            
            ZStack {
                
                VStack {

                    Header(
                        pathHandler: pathHandler,
                        title: headerTitle
                    )
                    
                    subButtonView
                    
                    Spacer()
                    
                    progressView
                    
                    Spacer()
                    
                    selectView
                        .frame(width: responsiveSize(280, 360))
                    
                    Spacer()
                    
                    StartButton(
                        label: "学習を開始 →",
                        color: Orange.defaultOrange
                    ) {
                        /// loading が必要？
                        
                        guard let selectedGrade = userInput.selectedGrade else { return }
                        
                        let cards = viewModel.cardsContainer.getCardsByLearnRange(
                            learnRange: userInput.selectedRange
                        )
                        
                        guard let options = SheetRealmAPI
                            .getOptions(
                                eikenGrade: selectedGrade,
                                cards: cards,
                                containFifthOption: false
                            ) else { return }
                        
                        pathHandler.transitionScreen(
                            to: userInput.selectedMode.bookViewName(
                                cards: cards,
                                options: options
                            )
                        )
                    }

                    Spacer()
                }
            }
            .background(CustomColor.background)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                adjustSelectedRange()
                viewModel.onAppearAction(userInput: userInput)
            }
    }
    
    @ViewBuilder
    var progressView: some View {
        
        HStack {
            
            LearnSelectCircle(
                
                firstCircle: .init(
                    value: viewModel.cardsContainer.learnedCount + viewModel.cardsContainer.learningCount,
                    color: RoyalBlue.semiOpaque
                ),
                
                secondCircle: .init(
                    value: viewModel.cardsContainer.learnedCount,
                    color: Orange.defaultOrange
                ),
                
                size: responsiveSize(140, 200),
                maxValue: viewModel.cardsContainer.allCount
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
            if viewModel.cardsContainer.notLearnedCount != viewModel.cardsContainer.allCount {
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
                pathHandler.transitionScreen(to: .wordList(viewModel.cardsContainer.allCards))
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
                
                guard let selectedBookCategory = userInput.selectedBookCategory else { return }
                
                guard SheetRealmAPI.resetCardsStatus(
                    cardIdList: viewModel.cardsContainer.allCards.map { $0.id },
                    bookCategory: selectedBookCategory
                ) else { return }
                
                viewModel.updateCardsContainer(userInput: userInput)

                loadingSharedData.finishLoading {}
            }
        }
    }
}


extension LearnSelectView {
    
    func adjustSelectedRange() {
        
        userInput.selectedRange = .notLearned
        
        if viewModel.cardsContainer.notLearnedCount == 0 {
            userInput.selectedRange = .learning
            
            if viewModel.cardsContainer.learningCount == 0 {
                userInput.selectedRange = .all
            }
        }
    }
}
