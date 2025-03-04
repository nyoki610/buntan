import SwiftUI

struct TypeView: ResponsiveView, LearnViewProtocol {
    
    @Environment(\.deviceType) var deviceType: DeviceType
    
    @EnvironmentObject var realmService: RealmService
    @EnvironmentObject var loadingSharedData: LoadingSharedData
    @EnvironmentObject var alertSharedData: AlertSharedData

    @EnvironmentObject var bookSharedData: BookSharedData
    @EnvironmentObject var checkSharedData: CheckSharedData
    @EnvironmentObject var learnManager: LearnManager
    
    /// this variable is not directly manipulated.
    @FocusState var isKeyboardActive: Bool

    @State var userInput: String = ""
    
    @State var isAnswering: Bool = true
    @State var isCorrect: Bool = true
    
    var body: some View {
        
        GeometryReader { geometry in
                
            VStack {
                
                LearnHeader(geometry: geometry,
                            learnMode: .type,
                            cards: bookSharedData.cards,
                            options: bookSharedData.options)
                
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
                    isAnswering ? passButtonAction() : nextCardExist ? nextButtonAction() : completeButtonAction()
                }
                            .padding(.top, 4)
                
                ///  View 調整用
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
            
            if deviceType == .iPhone {
                Spacer()
                Spacer()
            }
            
            Text(topCard.translation)
                .fontSize(responsiveSize(15, 28))
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
        
        TextField("", text: $userInput)
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
                
            Img.img(.circle,
                    size: responsiveSize(20, 28),
                    color: Orange.defaultOrange.opacity(isCorrect ? 1.0 : 0.0))
            .padding(.trailing, 10)
        }
    }
}

/*
 HStack {
     
     Button {
         backButtonAction()
     } label: {
         CustomImage(image: .arrowshapeTurnUpLeft,
                     size: 24,
                     color: .black, label: "ひとつ",
                     subLabel: "戻る")
     }
     /// 正解時はボタンを無効化
     .disabled(!isAnswering && isCorrect)
     
     Spacer()

     Button {
         learnManager.readOutTopCard(isButton: true)
     } label: {
         
         CustomImage(image: .speakerWave2Fill,
                     size: 24,
                     color: learnManager.buttonDisabled ? .gray : .black,
                     label: "音声を", subLabel: "再生")
     }
     .disabled(learnManager.buttonDisabled || isAnswering || isCorrect)
     .opacity(isAnswering || isCorrect ? 0.0 : 1.0)
     
     Button {
         isAnswering ? passButtonAction() : nextCardExist ? nextButtonAction() : completeButtonAction()
     } label: {
         CustomImage(
             image: isAnswering ? .arrowshapeTurnUpRight : .arrowshapeTurnUpRightFill,
             size: 24,
             color: isAnswering ? .black : RoyalBlue.defaultRoyal,
             label: isAnswering ? "パス" : (nextCardExist ? "次へ" : "完了"),
             subLabel: ""
         )
     }
     .padding(.leading, 16)
 }
 */
