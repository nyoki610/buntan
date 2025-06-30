import SwiftUI


struct CheckSelectView: SelectViewProtocol, CheckLearnViewProtocol {
    
    typealias ViewModelType = CheckSelectViewViewModel
    typealias UserInputType = CheckUserInput
    

    /// conformance to ResponsiveView
    @Environment(\.deviceType) var deviceType: DeviceType
    
    @EnvironmentObject var loadingSharedData: LoadingSharedData
    @EnvironmentObject var alertSharedData: AlertSharedData
    
    @StateObject var viewModel: CheckSelectViewViewModel
    @StateObject var userDefaultHandler: LearnUserDefaultHandler
    @ObservedObject var userInput: CheckUserInput
    @ObservedObject var pathHandler: CheckViewPathHandler
    
    init(
        pathHandler: CheckViewPathHandler,
        checkUserInput: CheckUserInput,
        cards: [Card],
        options: [[Option]]
    ) {

        self._pathHandler = ObservedObject(wrappedValue: pathHandler)
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
