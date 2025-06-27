import SwiftUI

struct BookSwipeView: BookLearnViewProtocol, SwipeViewProtocol {
    typealias ViewModelType = BookSwipeViewViewModel
    typealias UserInputType = BookUserInput
    
    
    @Environment(\.deviceType) var deviceType: DeviceType

    @EnvironmentObject var loadingSharedData: LoadingSharedData
    @EnvironmentObject var alertSharedData: AlertSharedData

    @StateObject var viewModel: BookSwipeViewViewModel
    @StateObject var userDefaultHandler: LearnUserDefaultHandler

    @ObservedObject var userInput: BookUserInput
    @ObservedObject var pathHandler: BookViewPathHandler
    
    init(
        pathHandler: BookViewPathHandler,
        bookUserInput: BookUserInput,
        cards: [Card],
        options: [[Option]]
    ) {
        self._pathHandler = ObservedObject(wrappedValue: pathHandler)
        self._userInput = ObservedObject(wrappedValue: bookUserInput)

        let handler = LearnUserDefaultHandler()
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
                    isFlipped: $viewModel.isFlipped,
                    isFlippedWithNoAnimation: $viewModel.isFlippedWithNoAnimation
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
