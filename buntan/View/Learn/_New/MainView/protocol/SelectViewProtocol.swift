import SwiftUI


protocol SelectViewProtocol: _LearnViewProtocol where
ViewModelType: BaseSelectViewModel {
//
//    associatedtype ViewModel: BaseSelectViewModel
//    var viewModel: ViewModel { get }
//    var userDefaultHandler: LearnUserDefaultHandler { get }
//    
//    /// saveAction()はView側で実装
//    func xmarkAction()
//    func saveAction()
//    
//    associatedtype SettingButtonsView: View
//    var settingButtons: SettingButtonsView { get }
}


extension SelectViewProtocol {
    
    @ViewBuilder
    internal func optionButtonListView(optionsCount: Int, saveAction: @escaping () -> Void) -> some View {
        
        ForEach(0...optionsCount, id: \.self) { i in
            optionButtonView(index: i)
                .disabled(!viewModel.isAnswering)
                .padding(.bottom, 10)
        }
    }

    
    @ViewBuilder
    private func optionButtonView(index: Int) -> some View {
        
        Button {
            viewModel.optionButtonAction(
                selectedOptionIndex: index,
                shouldReadOut: userDefaultHandler.shouldReadOut
            ) {
                saveAction()
            }
        } label: {
            
            HStack {
                
                Spacer()
                
                ZStack {
                    
                    VStack {
                        
                        Spacer()
                        
                        let buttonLabel = (index != 4) ? viewModel.options[viewModel.topCardIndex][index].meaning : "正解なし"

                        Text(buttonLabel)
                            .foregroundColor(.black)
                            .font(.system(size: responsiveSize(20, 28)))
                            .lineLimit(1)
                        
                        Spacer()
                    }
                    
                    if !viewModel.isAnswering && index == viewModel.selectedIndex {
                        
                        HStack {
                            
                            Image(systemName: viewModel.isCorrect ? "circle" : "xmark")
                                .font(.system(size: (index != 4) ? responsiveSize(30, 40) : 24))
                                .foregroundColor(viewModel.isCorrect ? Orange.defaultOrange : RoyalBlue.defaultRoyal)
                                .fontWeight(.bold)
                                .padding(.leading, responsiveSize(6, 12))
                            
                            Spacer()
                        }
                    }
                }
                
                Spacer()
            }
            .background(.white)
            .frame(
                width: (index != 4) ? responsiveSize(280, 340) : responsiveSize(160, 180),
                height: (index != 4) ? responsiveSize(60, 80) : responsiveSize(40, 48)
            )
            .overlay(
                optionButtonOverlay(index)
              )
            .cornerRadius(40)
            .shadow(radius: 2)
        }
    }
    
    /// 選択肢ボタンの装飾用
    /// 正解 or 不正解とユーザーの解答を基に色や図形を決定
    @ViewBuilder
    private func optionButtonOverlay(_ index: Int) -> some View {
        
        let isCorrect = index == viewModel.answerIndex
        let isActive = !viewModel.isAnswering && (isCorrect || index == viewModel.selectedIndex)
        let backgroundColor = isCorrect ? Orange.semiClear : RoyalBlue.semiClear
        let borderColor = isCorrect ? Orange.translucent : RoyalBlue.translucent

        if isActive {
            ZStack {
                backgroundColor
                RoundedRectangle(cornerRadius: 40)
                    .stroke(borderColor, lineWidth: 4)
            }
        }
    }
}
