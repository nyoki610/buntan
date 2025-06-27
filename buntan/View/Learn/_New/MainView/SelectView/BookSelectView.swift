import SwiftUI


struct BookSelectView:
    ResponsiveView,
    SelectViewProtocol,
    BookLearnViewProtocol {
    
    typealias ViewModelType = BookSelectViewViewModel
    typealias UserInputType = BookUserInput
    
    
    
    /// conformance to ResponsiveView
    @Environment(\.deviceType) var deviceType: DeviceType
    
    @EnvironmentObject var loadingSharedData: LoadingSharedData
    
    @StateObject var viewModel: BookSelectViewViewModel
    @StateObject var userDefaultHandler: LearnUserDefaultHandler
    @ObservedObject var userInput: BookUserInput
    @ObservedObject var pathHandler: PathHandler
    
    init(
        pathHandler: PathHandler,
        bookUserInput: BookUserInput,
        cards: [Card],
        options: [[Option]]
    ) {
        self._pathHandler = ObservedObject(wrappedValue: pathHandler)
        self._userInput = ObservedObject(wrappedValue: bookUserInput)

        let handler = LearnUserDefaultHandler()
        self._userDefaultHandler = StateObject(wrappedValue: handler)

        self._viewModel = StateObject(
            wrappedValue: BookSelectViewViewModel(
                cards: cards,
                options: options,
                shouldShuffle: handler.shouldShuffle
            )
        )
    }
    
    var body: some View {
        
//        swipeView(viewType: .book)
        GeometryReader { geometry in
            
            VStack {
                
                learnHeader(geometry: geometry)
                
                learnSettingButtons(
                    learnMode: .select,
                    showSetting: $viewModel.showSetting
                )
                
                Spacer()
                
                if userDefaultHandler.showSentence {
                    FlipSentenceCardView(card: viewModel.topCard,
                                         isSelectView: true)
                    
                } else {
                    FlipWordCardView(card: viewModel.topCard,
                                     showPhrase: true)
                    .disabled(true)
                }
                
                Spacer()
                
                optionButtonListView(optionsCount: 4) {
                    saveAction()
                }
                
                Spacer()
                
                learnBottomButtons
                    .disabled(!viewModel.isAnswering)
            }
            .background(CustomColor.background)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                viewModel.onAppearAction(shouldReadOut: userDefaultHandler.shouldReadOut)
            }
        }
    }
}
