import SwiftUI

struct BookSwipeView: BookLearnViewProtocol, SwipeViewProtocol {
    typealias ViewModelType = BookSwipeViewViewModel
    typealias UserInputType = BookUserInput


    @EnvironmentObject var loadingManager: LoadingManager
    @EnvironmentObject var alertManager: AlertManager

    @StateObject var viewModel: BookSwipeViewViewModel
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
            wrappedValue: BookSwipeViewViewModel(
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
                    learnMode: .swipe,
                    showSetting: $viewModel.showSetting
                )

                Spacer()

                cardView(
                    isWordCardFlipped: $viewModel.isWordCardFlipped,
                    isWordCardFlippedWithNoAnimation: $viewModel.isWordCardFlippedWithNoAnimation,
                    isSentenceCardFlipped: $viewModel.isSentenceCardFlipped,
                    isSentenceCardFlippedWithNoAnimation: $viewModel.isSentenceCardFlippedWithNoAnimation
                )

                Spacer()
                
                learnBottomButtons
            }
            .background(CustomColor.background)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                viewModel.onAppearAction(shouldReadOut: userDefaultHandler.shouldReadOut)
            }
        }
    }
}
