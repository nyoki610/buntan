import SwiftUI


struct BookLearnSelectView: ResponsiveView, BookLearnViewProtocol, SelectViewProtocol {
    
    
    /// conformance to ResponsiveView
    @Environment(\.deviceType) var deviceType: DeviceType
    
    /// Conformance to BookLearnViewProtocol
    @ObservedObject var userDefaultHandler: LearnUserDefaultHandler
    @ObservedObject var learnManager: BookLearnManager
    @EnvironmentObject var loadingSharedData: LoadingSharedData
    @EnvironmentObject var alertSharedData: AlertSharedData
    @ObservedObject var userInput: BookUserInput
    
    @ObservedObject internal var viewModel: SwipeViewViewModel
    
    @ObservedObject var pathHandler: PathHandler
    
    init(
        pathHandler: PathHandler, 
        userInput: BookUserInput,
        learnManager: BookLearnManager,
        userDefaultHandler: LearnUserDefaultHandler,
        isBookView: Bool
    ) {
        self.pathHandler = pathHandler
        self.userInput = userInput
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
                        learnManager.bookSaveAction(
                            pathHandler: pathHandler,
                            loadingSharedData: loadingSharedData,
                            userInput: userInput
                        )
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
                
                optionListView(optionsCount: 4) {
                    learnManager.bookSaveAction(
                        pathHandler: pathHandler,
                        loadingSharedData: loadingSharedData,
                        userInput: userInput
                    )
                }
                
                Spacer()
                
                SelectLearnButtomButtons {
                    
                    Task {
                        await viewModel.buttonAction(
                            index: -1,
                            shouldReadOut: userDefaultHandler.shouldReadOut
                        ) {
                            learnManager.bookSaveAction(
                                pathHandler: pathHandler,
                                loadingSharedData: loadingSharedData,
                                userInput: userInput
                            )
                        }
                    }
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
}
