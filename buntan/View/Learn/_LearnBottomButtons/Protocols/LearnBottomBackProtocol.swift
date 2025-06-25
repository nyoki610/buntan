import SwiftUI


protocol LearnBottomBackProtocol: LearnBottomButtonsProtocol {
    
    var alertSharedData: AlertSharedData { get }
}


extension LearnBottomBackProtocol {
    
    internal func backButtons() -> some View {
        
        HStack {
            customButton(label: "ひとつ",
                         subLabel: "戻る",
                         systemName: "arrowshape.turn.up.left") {
                guard let bookLearnManager = learnManager as? BookLearnManager else { return }
                bookLearnManager.backButtonAction()
            }
                         .padding(.trailing, 16)
                      
            customButton(label: "最初に",
                         subLabel: "戻る",
                         systemName: "arrowshape.turn.up.backward.2") {
                backToStart()
            }
        }
    }
    
    private func backToStart() -> Void {
        
        if learnManager.topCardIndex > 0 {
            alertSharedData.showSelectiveAlert(
                title: "最初に戻りますか？",
                message: "",
                secondaryButtonLabel: "最初から",
                secondaryButtonType: .defaultButton
            ) {
                while learnManager.topCardIndex > 0 {
                    guard let bookLearnManager = learnManager as? BookLearnManager else { return }
                    bookLearnManager.backButtonAction()
                }
            }
        }
    }
}
