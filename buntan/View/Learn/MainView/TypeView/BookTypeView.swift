import SwiftUI

struct BookTypeView: View, BookLearnViewProtocol, TypeViewProtocol {
    typealias ViewModelType = BookTypeViewViewModel
    typealias UserInputType = BookUserInput
    

    
    @EnvironmentObject var loadingManager: LoadingManager
    
    /// this variable is not directly manipulated.
    @FocusState var isKeyboardActive: Bool

    @StateObject var viewModel: BookTypeViewViewModel
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

        let handler = LearnUserDefaultHandler.shared
        self._userDefaultHandler = StateObject(wrappedValue: handler)

        self._viewModel = StateObject(
            wrappedValue: BookTypeViewViewModel(
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
                    learnMode: .type,
                    showSetting: $viewModel.showSetting
                )
                
                Spacer()
                
                sentenceView
                    .padding(.horizontal, 40)
                
                Spacer()
                
                answerView(
                    userInputAnswer: $viewModel.userInputAnswer,
                    isKeyboardActive: $isKeyboardActive
                )
                    .padding(.horizontal, responsiveSize(40, 120))
                
                learnBottomButtons
                    .padding(.top, 4)
                
                ///  View 調整用？
                VStack {
                    Spacer()
                }
                .border(.red)
                .frame(height: 320)
            }
            .background(CustomColor.background)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                viewModel.onAppearAction()
            }
            /// link variables to manipulate keyboard status from learnManager
            .onChange(of: viewModel.isKeyboardActive) { newValue in isKeyboardActive = newValue }
        }
        .ignoresSafeArea(.keyboard)
    }
}
