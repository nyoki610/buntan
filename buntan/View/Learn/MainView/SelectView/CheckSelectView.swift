import SwiftUI


struct CheckSelectView: SelectViewProtocol, CheckLearnViewProtocol {
    
    typealias ViewModelType = CheckSelectViewViewModel
    typealias UserInputType = CheckUserInput
    
    @EnvironmentObject var loadingManager: LoadingManager
    @EnvironmentObject var alertManager: AlertManager
    
    @StateObject var viewModel: CheckSelectViewViewModel
    @StateObject var userDefaultHandler: LearnUserDefaultHandler
    @ObservedObject var userInput: CheckUserInput
    let navigator: CheckNavigator
    
    init(
        navigator: CheckNavigator,
        checkUserInput: CheckUserInput,
        cards: [Card],
        options: [[Option]]
    ) {

        self.navigator = navigator
        self._userInput = ObservedObject(wrappedValue: checkUserInput)

        let handler = LearnUserDefaultHandler()
        self._userDefaultHandler = StateObject(wrappedValue: handler)

        self._viewModel = StateObject(
            wrappedValue: CheckSelectViewViewModel(
                cards: cards,
                options: options
            )
        )
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack {
                
                learnHeader(geometry: geometry)
                
                learnSettingButtons(
                    showSetting: $viewModel.showSetting
                )
                
                Spacer()
                
                cardView(viewType: .check)
                
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
