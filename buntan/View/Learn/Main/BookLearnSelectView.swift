import SwiftUI


struct BookLearnSelectView: ResponsiveView, BookLearnViewProtocol {
    
    @Environment(\.deviceType) var deviceType: DeviceType
    
    @EnvironmentObject var loadingSharedData: LoadingSharedData
    @EnvironmentObject var alertSharedData: AlertSharedData

    /// BookView と CheckView で処理を分けるための変数
    /// init 時に外部から受け取る
    let isBookView: Bool
    
    internal var viewModel: SwipeViewViewModel
    
    @ObservedObject var pathHandler: PathHandler
    @ObservedObject var userInput: UserInput
    @ObservedObject var learnManager: BookLearnManager
    @ObservedObject var userDefaultHandler: LearnUserDefaultHandler
    
    init(
        pathHandler: PathHandler, 
        userInput: UserInput, 
        learnManager: BookLearnManager,
        userDefaultHandler: LearnUserDefaultHandler,
        isBookView: Bool
    ) {
        self.pathHandler = pathHandler
        self.userInput = userInput
        self.isBookView = isBookView
        self.learnManager = learnManager
        self.userDefaultHandler = userDefaultHandler
        self.viewModel = SwipeViewViewModel(learnManager: learnManager)
    }
    
    var body: some View {

        GeometryReader { geometry in
            
            VStack {
                
                _LearnHeader(
                    learnManager: learnManager,
                    geometry: geometry) {
                        saveAction(pathHandler: pathHandler)
                    }
                
                Spacer()
                
                /// BookView かつ showSentence = true の場合
//                if learnManager.showSentence && isBookView {
                if userDefaultHandler.showSentence {
                    FlipSentenceCardView(card: topCard,
                                         isSelectView: true)
                    
                /// 以下のいずれかの場合
                ///     - BookView かつ showSentence = false
                ///     - CheckView
                } else {
                    FlipWordCardView(card: topCard,
                                     showPhrase: true)
                    .disabled(true)
                }
                
                Spacer()
                
                /// BookView -> 選択肢４つ
                /// CheckView -> 選択肢４つ＋「正解なし」ボタン
                ForEach(0...(isBookView ? 3 : 4), id: \.self) { i in
                    optionView(i)
                        .disabled(!viewModel.isAnswering)
                        .padding(.bottom, 10)
                }
                
                Spacer()
                
                SelectLearnButtomButtons {
                    
                    Task { await viewModel.buttonAction(
                        index: -1,
                        shouldReadOut: userDefaultHandler.shouldReadOut
                    ) {
                        saveAction(pathHandler: pathHandler)
                    } }
                }
                .disabled(!viewModel.isAnswering)
            }
            .background(CustomColor.background)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                viewModel.onAppearAction()
            }
        }
    }
    
    @ViewBuilder
    private func optionView(_ index: Int) -> some View {
        
        Button {
            
            Task { await viewModel.buttonAction(
                index: index,
                shouldReadOut: userDefaultHandler.shouldReadOut
            ) {
                saveAction(pathHandler: pathHandler)
            } }
            
        } label: {
            
            HStack {
                
                Spacer()
                
                ZStack {
                    
                    VStack {
                        
                        Spacer()
                        
                        let buttonLabel = (index != 4) ? learnManager.options[topCardIndex][index].meaning : "正解なし"

                        Text(buttonLabel)
                            .foregroundColor(.black)
                            .font(.system(size: responsiveSize(20, 28)))
                            .lineLimit(1)
                        
                        Spacer()
                    }
                    
                    if !viewModel.isAnswering && index == viewModel.selectedIndex {
                        
                        HStack {
                            
                            Image(systemName: viewModel.isCorrect ? "circle" : "xmark")
                                .font(.system(size: (index != 4) ? responsiveSize(30, 40) : 24))
                                .foregroundColor(viewModel.isCorrect ? Orange.defaultOrange : RoyalBlue.defaultRoyal)
                                .fontWeight(.bold)
                                .padding(.leading, responsiveSize(6, 12))
                            
                            Spacer()
                        }
                    }
                }
                
                Spacer()
            }
            .background(.white)
            .frame(width: (index != 4) ? responsiveSize(280, 340) : responsiveSize(160, 180),
                   height: (index != 4) ? responsiveSize(60, 80) : responsiveSize(40, 48))
            .overlay(
                buttonOverlay(index)
              )
            .cornerRadius(40)
            .shadow(radius: 2)
        }
    }
    
    /// 選択肢ボタンの装飾用
    /// 正解 or 不正解とユーザーの解答を基に色や図形を決定
    @ViewBuilder
    private func buttonOverlay(_ index: Int) -> some View {
        
        let isCorrect = index == viewModel.answerIndex
        let isActive = !viewModel.isAnswering && (isCorrect || index == viewModel.selectedIndex)
        let backgroundColor = isCorrect ? Orange.semiClear : RoyalBlue.semiClear
        let borderColor = isCorrect ? Orange.translucent : RoyalBlue.translucent

        if isActive {
            ZStack {
                backgroundColor
                RoundedRectangle(cornerRadius: 40)
                    .stroke(borderColor, lineWidth: 4)
            }
        }
    }
}
