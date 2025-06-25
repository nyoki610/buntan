import SwiftUI

struct LearnBottomButtons: LearnBottomButtonsProtocol, LearnBottomBackProtocol {
    
    @Environment(\.deviceType) var deviceType: DeviceType

    @EnvironmentObject var alertSharedData: AlertSharedData
    @EnvironmentObject var learnManager: _LearnManager
    
    var body: some View {

        bottomButtonsFrame {
            
            if learnManager.topCardIndex > 0 {
                backButtons()
            }
            
            Spacer()
            
            readOutTopCardButton()
        }
    }
}
