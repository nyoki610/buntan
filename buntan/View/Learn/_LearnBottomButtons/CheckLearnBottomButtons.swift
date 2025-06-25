import SwiftUI


struct CheckLearnBottomButtons: LearnBottomButtonsProtocol, LearnBottomPassProtocol {
    
    @Environment(\.deviceType) var deviceType: DeviceType

    @EnvironmentObject var learnManager: _LearnManager
    
    let passAction: (() -> Void)
    
    init(passAction: @escaping (() -> Void) = {}) {
        self.passAction = passAction
    }
    
    var body: some View {
        
        bottomButtonsFrame {
            Spacer()
            
            readOutTopCardButton()
            
            // 連打を防がなくても良い?
            passButton()
            .padding(.leading, 16)
        }
    }
}
