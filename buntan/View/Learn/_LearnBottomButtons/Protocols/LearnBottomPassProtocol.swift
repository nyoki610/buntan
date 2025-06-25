import SwiftUI


protocol LearnBottomPassProtocol: LearnBottomButtonsProtocol {
    
    var passAction: (() -> Void) { get }
}


extension LearnBottomPassProtocol {
    
    /// ViewBuilder は不要?
    internal func passButton() -> some View {
        
        customButton(label: "パス",
                     subLabel: "",
                     systemName: "arrowshape.turn.up.right") {
            passAction()
        }
        .disabled(learnManager.buttonDisabled)
    }
}
