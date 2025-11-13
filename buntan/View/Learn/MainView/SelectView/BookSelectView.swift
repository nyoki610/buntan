import SwiftUI


struct BookSelectView: SelectViewProtocol, BookLearnViewProtocol {
    
    typealias ViewModelType = BookSelectViewViewModel
    typealias UserInputType = BookUserInput
    
    @EnvironmentObject var loadingManager: LoadingManager
    
    @StateObject var viewModel: BookSelectViewViewModel
    @StateObject var userDefaultHandler: LearnUserDefaultHandler
    @ObservedObject var userInput: BookUserInput
    let navigator: BookNavigator
    
    init(
        navigator: BookNavigator,
        bookUserInput: BookUserInput,
        cards: [Card],
        options: [[Option]]
    ) {
        self.navigator = navigator
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

        GeometryReader { geometry in
            
            VStack {
                
                learnHeader(geometry: geometry)
                
                learnSettingButtons(
                    learnMode: .select,
                    showSetting: $viewModel.showSetting
                )
                
                Spacer()
                
                cardView(viewType: .book)
                
                Spacer()
                
                optionButtonListView
                
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
