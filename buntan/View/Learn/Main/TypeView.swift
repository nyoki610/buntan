import SwiftUI

struct TypeView: ResponsiveView, LearnViewProtocol {
    
    @Environment(\.deviceType) var deviceType: DeviceType
    
    @EnvironmentObject var loadingSharedData: LoadingSharedData
    @EnvironmentObject var alertSharedData: AlertSharedData
    @EnvironmentObject var learnManager: LearnManager
    
    /// this variable is not directly manipulated.
    @FocusState var isKeyboardActive: Bool

    @State var userInputAnswer: String = ""
    @State var isAnswering: Bool = true
    @State var isCorrect: Bool = true
    
    @ObservedObject var pathHandler: _PathHandler
    @ObservedObject var userInput: UserInput
    
    private let cards: [Card]
    private let options: [[Option]]?
    
    init(pathHandler: _PathHandler, userInput: UserInput, cards: [Card], options: [[Option]]?) {
        self.pathHandler = pathHandler
        self.userInput = userInput
        self.cards = cards
        self.options = options
    }
    
    var body: some View {
        
        GeometryReader { geometry in
                
            VStack {
                
                LearnHeader(pathHandler: pathHandler,
                            userInput: userInput,
                            geometry: geometry,
                            learnMode: .type,
                            cards: cards,
                            options: options)
                
                Spacer()
                
                sentenceView
                    .padding(.horizontal, 40)
                
                Spacer()
                
                answerView
                    .padding(.horizontal, responsiveSize(40, 120))
                
                LearnButton(learnMode: .type,
                            hideSpeaker: isAnswering || isCorrect,
                            isAnswering: isAnswering,
                            nextCardExist: nextCardExist) {
                    isAnswering ? passButtonAction() :
                    nextCardExist ? nextButtonAction() : completeButtonAction()
                }
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
                onAppearAction()
            }
            /// link variables to manipulate keyboard status from learnManager
            .onChange(of: learnManager.isKeyboardActive) { newValue in isKeyboardActive = newValue }
        }
        .ignoresSafeArea(.keyboard)
    }
    
    @ViewBuilder
    private var sentenceView: some View {
        
        VStack {
            Spacer()
            
            Text(CustomText.replaceAnswer(card: topCard, showInitial: learnManager.showInitial))
                .fontSize(responsiveSize(20, 28))
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(3)
            
            /// iPhone or iPad で View を調整
            if deviceType == .iPhone {
                Spacer()
                Spacer()
            }
            
            Text(topCard.translation)
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
            Text(topCard.posPrefix(topCard.meaning))
                .fontWeight(.medium)
                .fontSize(responsiveSize(18, 24))
                .lineLimit(1)
            
            Spacer()
        }
        
         
        ZStack {
            isAnswering ? AnyView(isAnsweringView) : AnyView(notAnsweringView)
        }
        .frame(height: 40)
        .overlay(
            Rectangle()
                .frame(height: 4.0)
                .foregroundColor(isAnswering ? .gray : isCorrect ? Orange.defaultOrange : RoyalBlue.defaultRoyal),
            alignment: .bottom
            )
    }
    
    @ViewBuilder
    private var isAnsweringView: some View {
        
        TextField("", text: $userInputAnswer)
            .fontSize(responsiveSize(20, 28))
            .autocapitalization(.none)
            .autocorrectionDisabled()
            .focused($isKeyboardActive)
            .onSubmit {
                submitAction()
            }
    }
    
    @ViewBuilder
    private var notAnsweringView: some View {
        
        let word = topCard.word
        let answer = topCard.answer
        let isSame = (word == answer)

        HStack {
            
            Text(isSame ? answer : "\(answer) (\(word))")
                .fontSize(responsiveSize(20, 28))
                .foregroundColor(isCorrect ? Orange.defaultOrange : RoyalBlue.defaultRoyal)
                .bold()
            
            Spacer()
                
            Image(systemName: "circle")
                .font(.system(size: responsiveSize(20, 28)))
                .fontWeight(.bold)
                .foregroundStyle(Orange.defaultOrange.opacity(isCorrect ? 1.0 : 0.0))
                .padding(.trailing, 10)
        }
    }
}
