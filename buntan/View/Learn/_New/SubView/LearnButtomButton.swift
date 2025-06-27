import SwiftUI

struct LearnBottomButtons: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType: DeviceType

    @EnvironmentObject var alertSharedData: AlertSharedData
    
    @ObservedObject var viewModel: BaseLearnViewViewModel
    
    private let learnMode: LearnMode?
    
    private var showSpeaker: Bool? {
        
        if learnMode != .type { return true }
        
        guard let typeViewModel = viewModel as? BaseTypeViewViewModel else { return nil }
        
        return !typeViewModel.hideSpealer
        
    }
    
    private let shouldReadOut: Bool
    
    private let saveAction: () -> Void
    
    init?(viewModel: BaseLearnViewViewModel, shouldReadOut: Bool, saveAction: @escaping () -> Void) {
        
        let learnMode: LearnMode?
        
        switch viewModel {
        case is BookSwipeViewViewModel: learnMode = .swipe
        case is BookSelectViewViewModel: learnMode = .select
        case is BookTypeViewViewModel: learnMode = .type
        case is CheckSelectViewViewModel: learnMode = nil
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
                customButton(
                    label: typeViewModel.isAnswering ? "パス" : (typeViewModel.nextCardExist ? "次へ" : "完了"),
                    subLabel: "",
                    systemName: typeViewModel.isAnswering ? "arrowshape.turn.up.right" : "arrowshape.turn.up.right.fill",
                    color: typeViewModel.isAnswering ? .black : RoyalBlue.defaultRoyal
                ) {
                    typeViewModel.isAnswering ?
                    typeViewModel.passButtonAction(shouldReadOut: shouldReadOut) :
                    
                    typeViewModel.nextCardExist ?
                    typeViewModel.nextButtonAction() :
                    
                    typeViewModel.completeButtonAction() {
                        saveAction()
                    }
                }
                .padding(.leading, 16)
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
