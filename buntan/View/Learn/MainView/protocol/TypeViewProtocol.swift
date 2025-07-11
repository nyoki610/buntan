import SwiftUI


protocol TypeViewProtocol: _LearnViewProtocol where
ViewModelType: BaseTypeViewViewModel {}


extension TypeViewProtocol {
    
    @ViewBuilder
    internal var sentenceView: some View {
        
        VStack {
            Spacer()
            
            if let clozeAnswer = viewModel.topCard.clozeAnswer {
                
                var targetSubString: String {
                    guard clozeAnswer.count >= 2 else { return clozeAnswer }
                    
                    if userDefaultHandler.showInitial {
                        return String(clozeAnswer.dropFirst())
                    } else {
                        return clozeAnswer
                    }
                }
                
                Text(
                    CustomText.replaceSubstring(
                        in: viewModel.topCard.sentence,
                        targetSubstring: targetSubString
                    )
                )
                    .fontSize(responsiveSize(20, 28))
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(3)
            }
            
            /// iPhone or iPad で View を調整
            if DeviceType.getDeviceType() == .iPhone {
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
    internal func answerView(
        userInputAnswer: Binding<String>,
        isKeyboardActive: FocusState<Bool>.Binding
    ) -> some View {

        VStack {
            HStack {
                Text(viewModel.topCard.posPrefix(viewModel.topCard.meaning))
                    .fontWeight(.medium)
                    .fontSize(responsiveSize(18, 24))
                    .lineLimit(1)
                
                Spacer()
            }
            
             
            VStack {
                if viewModel.isAnswering {
                    isAnsweringView(
                        userInputAnswer: userInputAnswer,
                        isKeyboardActive: isKeyboardActive
                    )
                } else {
                    notAnsweringView
                }
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
    }
    
    @ViewBuilder
    private func isAnsweringView(
        userInputAnswer: Binding<String>,
        isKeyboardActive: FocusState<Bool>.Binding
    ) -> some View {
        
        TextField("", text: userInputAnswer)
            .fontSize(responsiveSize(20, 28))
            .autocapitalization(.none)
            .autocorrectionDisabled()
            .focused(isKeyboardActive )
            .onSubmit {
                Task {
                    let shouldSave = await viewModel.submitAction(shouldReadOut: userDefaultHandler.shouldReadOut)
                    
                    /// 最後の単語かつ正解している場合
                    /// （不正解の場合は完了ボタンから遷移）
                    if shouldSave && viewModel.isCorrect {
                        saveAction()
                    }
                }
            }
    }
    
    @ViewBuilder
    private var notAnsweringView: some View {
        
        var label: String {
            /// `clozeAnswer` が存在し、かつ `word` と異なる場合にのみ`(word)`を追加する
            if let clozeAnswer = viewModel.topCard.clozeAnswer, clozeAnswer != viewModel.topCard.word {
                return "\(clozeAnswer) (\(viewModel.topCard.word))"
            } else {
                /// `clozeAnswer` が nil の場合、または `clozeAnswer` が `word` と同じ場合は `word` のみを表示
                return viewModel.topCard.word
            }
        }

        HStack {
            
            Text(label)
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
