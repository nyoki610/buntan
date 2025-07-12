import SwiftUI

struct LearnBottomButtons: View {
    
    enum ViewType {
        case bookSwipe
        case bookSelect
        case bookType
        case checkSelect
    }


    @EnvironmentObject var alertSharedData: AlertSharedData
    
    @ObservedObject var viewModel: BaseLearnViewViewModel
    
    private let learnMode: ViewType
    
    private var showSpeaker: Bool? {
        
        if learnMode != .bookType { return true }
        
        guard let typeViewModel = viewModel as? BaseTypeViewViewModel else { return nil }
        
        return !typeViewModel.hideSpealer
        
    }
    
    private let shouldReadOut: Bool
    
    private let saveAction: () -> Void
    
    init?(viewModel: BaseLearnViewViewModel, shouldReadOut: Bool, saveAction: @escaping () -> Void) {
        
        let learnMode: ViewType
        
        switch viewModel {
        case is BookSwipeViewViewModel: learnMode = .bookSwipe
        case is BookSelectViewViewModel: learnMode = .bookSelect
        case is BookTypeViewViewModel: learnMode = .bookType
        case is CheckSelectViewViewModel: learnMode = .checkSelect
        default: return nil
        }
        self.viewModel = viewModel
        self.learnMode = learnMode
        self.shouldReadOut = shouldReadOut
        self.saveAction = saveAction
    }
    
    var body: some View {

        HStack {
            
            if let bookLearnViewModel = viewModel as? any BookLearnViewViewModelProtocol {
                
                if viewModel.topCardIndex > 0 {
                    
                    customButton(
                        label: "ひとつ",
                        subLabel: "戻る",
                        systemName: "arrowshape.turn.up.left"
                    ) {
                        
                        switch viewModel {
                        case let bookTypeViewModel as BaseTypeViewViewModel:
                            bookTypeViewModel.typeViewBackButtonAction {
                                bookLearnViewModel.backButtonAction()
                            }
                        case is BaseSelectViewViewModel, is BaseSwipeViewViewModel:
                            bookLearnViewModel.backButtonAction()
                        default: return
                        }
                    }
                    
                    customButton(
                        label: "最初に",
                        subLabel: "戻る",
                        systemName: "arrowshape.turn.up.backward.2"
                    ) {
                        bookLearnViewModel.backToStart(alertSharedData: alertSharedData)
                    }
                                 .padding(.leading, 16)
                }
            }
            
            Spacer()
            
            if showSpeaker == true {
                customButton(
                    label: "音声を",
                    subLabel: "再生",
                    systemName: "speaker.wave.2.fill",
                    color: viewModel.readOutButtonDisabled ? .gray : .black
                ) {
                    viewModel.readOutTopCard(withDelay: false)
                }
                .disabled(viewModel.readOutButtonDisabled)
            }
            
            if let selectViewModel = viewModel as? BaseSelectViewViewModel {
                customButton(
                    label: "パス",
                    subLabel: "",
                    systemName: "arrowshape.turn.up.right"
                ) {
                    selectViewModel.passAction(shouldReadOut: shouldReadOut) {
                        saveAction()
                    }
                }
                .padding(.leading, 16)
            }
            
            if let typeViewModel = viewModel as? BaseTypeViewViewModel {
                
                if typeViewModel.isAnswering {
                    customButton(
                        label: "パス",
                        subLabel: "",
                        systemName: "arrowshape.turn.up.right",
                        color: .black
                    ) {
                        typeViewModel.passButtonAction(shouldReadOut: shouldReadOut)
                    }
                    .padding(.leading, 16)
                    
                } else {
                    
                    customButton(
                        label: typeViewModel.nextCardExist ? "次へ" : "完了",
                        subLabel: "",
                        systemName: "arrowshape.turn.up.right.fill",
                        color: RoyalBlue.defaultRoyal
                    ) {
                        typeViewModel.nextCardExist ?
                        typeViewModel.nextButtonAction() :
                        typeViewModel.completeButtonAction() {
                            saveAction()
                        }
                    }
                    .padding(.leading, 16)
                    /// if typeViewModel.isCorrect { による分岐で実装すると,
                    /// 1単語目でViewの表示が崩れてしまうため, opacityで対応
                    .opacity(typeViewModel.isCorrect ? 0.0 : 1.0)
                }
            }
        }
        .padding(.horizontal, responsiveSize(50, 140))
        .padding(.bottom, responsiveSize(10, 30))
    }
    
    @ViewBuilder
    private func customButton(
        label: String,
        subLabel: String,
        systemName: String,
        color: Color = .black,
        action: @escaping () -> Void = {}
    ) -> some View {
        
        let size = responsiveSize(24, 36)
        
        Button(action: action) {
            
            VStack {
                
                Image(systemName: systemName)
                    .font(.system(size: size))
                
                VStack {
                    Text(label)
                    Text(subLabel)
                }
                .font(.system(size: size/2))
                .padding(.top, 4)
            }
            .fontWeight(.bold)
            .foregroundStyle(color)
        }
    }
}
