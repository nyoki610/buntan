import SwiftUI

struct SelectLearnButtomButtons: LearnBottomButtonsProtocol, LearnBottomBackProtocol, LearnBottomPassProtocol {
    
    @Environment(\.deviceType) var deviceType: DeviceType

    @EnvironmentObject var alertSharedData: AlertSharedData
    @EnvironmentObject var learnManager: _LearnManager
    
    let passAction: (() -> Void)
    
    init(passAction: @escaping (() -> Void) = {}) {
        self.passAction = passAction
    }
    
    var body: some View {

        bottomButtonsFrame {
            
            if learnManager.topCardIndex > 0 {
                backButtons()
            }
            
            Spacer()
            
            readOutTopCardButton()
            
            // 連打を防がなくても良い?
            passButton()
            .padding(.leading, 16)
        }
    }
}
