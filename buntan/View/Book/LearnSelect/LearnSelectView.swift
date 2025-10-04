import SwiftUI


struct LearnSelectView: View {
    
    @EnvironmentObject var alertManager: AlertManager
    @EnvironmentObject var loadingManager: LoadingManager
    
    @ObservedObject private var navigator: BookNavigator
    @ObservedObject var userInput: BookUserInput
    
    @StateObject var viewModel: LearnSelectViewViewModel
    
    init(
        navigator: BookNavigator,
        userInput: BookUserInput,
        cardsContainer: CardsContainer
    ) {
        self.navigator = navigator
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
                        navigator: navigator,
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
                        
                        let createOptionsUseCase = CreateOptionsUseCase()
                        guard let options = try? createOptionsUseCase.execute(
                            from: cards,
                            for: selectedGrade,
                            withFifthOption: false
                        ) else { return }
                        
                        navigator.push(
                            userInput.selectedMode.bookViewName(
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
                viewModel.onAppearAction(userInput: userInput)
                adjustSelectedRange()
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
                navigator.push(.wordList(viewModel.cardsContainer.allCards))
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
        
        let config = AlertManager.SelectiveAlertConfig(
            title: "現在の進捗を\nリセットしますか？",
            message: nil,
            secondaryButtonLabel: "リセット",
            secondaryButtonType: .destructive
        ) {
            Task {
                await loadingManager.startLoading(.process)
                
                /// ensure loading screen rendering by delaying the next process
                let delay: UInt64 = 100_000_000
                try? await Task.sleep(nanoseconds: delay)
                
                guard let selectedBookCategory = userInput.selectedBookCategory else { return }
                
                let resetCardsStatusUseCase = ResetCardsStatusUseCase()
                try? resetCardsStatusUseCase.execute(
                    of: viewModel.cardsContainer.allCards,
                    category: selectedBookCategory
                )
                
                viewModel.updateCardsContainer(userInput: userInput)
                adjustSelectedRange()
                
                await loadingManager.finishLoading()
            }
        }
        alertManager.showAlert(type: .selective(config: config))
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
