import SwiftUI

struct BookTypeView: ResponsiveView, BookLearnViewProtocol {
    
    @Environment(\.deviceType) var deviceType: DeviceType
    
    @EnvironmentObject var loadingSharedData: LoadingSharedData
    
    /// this variable is not directly manipulated.
    @FocusState var isKeyboardActive: Bool

    @StateObject var viewModel: BookTypeViewViewModel
    @ObservedObject var userDefaultHandler: LearnUserDefaultHandler
    @ObservedObject var bookUserInput: BookUserInput
    @ObservedObject var pathHandler: PathHandler
    
    init(
        pathHandler: PathHandler,
        bookUserInput: BookUserInput,
        cards: [Card],
        options: [[Option]]
    ) {
        self.pathHandler = pathHandler
        self.bookUserInput = bookUserInput
        let userDefaultHandler = LearnUserDefaultHandler()
        self._viewModel = StateObject(
            wrappedValue: BookTypeViewViewModel(
                cards: cards,
                options: options,
                shouldShuffle: userDefaultHandler.shouldShuffle
            )
        )
        self.userDefaultHandler = userDefaultHandler
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
                
                answerView
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
    
    @ViewBuilder
    private var sentenceView: some View {
        
        VStack {
            Spacer()
            
            Text(CustomText.replaceAnswer(
                card: viewModel.topCard,
                showInitial: userDefaultHandler.showInitial
            ))
                .fontSize(responsiveSize(20, 28))
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(3)
            
            /// iPhone or iPad で View を調整
            if deviceType == .iPhone {
                Spacer()
                Spacer()
            }
            
            Text(viewModel.topCard.translation)
                .fontSize(responsiveSize(18, 28))
                .padding(.top, responsiveSize(0, 12))
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(2)
            
            Spacer()
        }
    }
    
    @ViewBuilder
    private var answerView: some View {

        HStack {
            Text(viewModel.topCard.posPrefix(viewModel.topCard.meaning))
                .fontWeight(.medium)
                .fontSize(responsiveSize(18, 24))
                .lineLimit(1)
            
            Spacer()
        }
        
         
        ZStack {
            viewModel.isAnswering ? AnyView(isAnsweringView) : AnyView(notAnsweringView)
        }
        .frame(height: 40)
        .overlay(
            Rectangle()
                .frame(height: 4.0)
                .foregroundColor(
                    viewModel.isAnswering ? .gray : viewModel.isCorrect ? Orange.defaultOrange : RoyalBlue.defaultRoyal
                ),
            alignment: .bottom
            )
    }
    
    @ViewBuilder
    private var isAnsweringView: some View {
        
        TextField("", text: $viewModel.userInputAnswer)
            .fontSize(responsiveSize(20, 28))
            .autocapitalization(.none)
            .autocorrectionDisabled()
            .focused($isKeyboardActive)
            .onSubmit {
                viewModel.submitAction(shouldReadOut: userDefaultHandler.shouldReadOut)
                
                if !viewModel.nextCardExist {
                    saveAction()
                }
            }
    }
    
    @ViewBuilder
    private var notAnsweringView: some View {
        
        let word = viewModel.topCard.word
        let answer = viewModel.topCard.answer
        let isSame = (word == answer)

        HStack {
            
            Text(isSame ? answer : "\(answer) (\(word))")
                .fontSize(responsiveSize(20, 28))
                .foregroundColor(viewModel.isCorrect ? Orange.defaultOrange : RoyalBlue.defaultRoyal)
                .bold()
            
            Spacer()
                
            Image(systemName: "circle")
                .font(.system(size: responsiveSize(20, 28)))
                .fontWeight(.bold)
                .foregroundStyle(Orange.defaultOrange.opacity(viewModel.isCorrect ? 1.0 : 0.0))
                .padding(.trailing, 10)
        }
    }
}
