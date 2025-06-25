import SwiftUI


struct TypeLearnBottomButtons: LearnBottomButtonsProtocol, LearnBottomBackProtocol {
    
    @Environment(\.deviceType) var deviceType: DeviceType

    @EnvironmentObject var alertSharedData: AlertSharedData
    @EnvironmentObject var learnManager: _LearnManager
    
    let hideSpeaker: Bool
    let isAnswering: Bool
    let nextCardExist: Bool
    let passAction: (() -> Void)
    
    init(
        hideSpeaker: Bool = false,
        isAnswering: Bool = false,
        nextCardExist: Bool = false,
        passAction: @escaping (() -> Void) = {}
    ) {
        self.hideSpeaker = hideSpeaker
        self.isAnswering = isAnswering
        self.nextCardExist = nextCardExist
        self.passAction = passAction
    }
    
    var body: some View {

        bottomButtonsFrame {
            
            if learnManager.topCardIndex > 0 {
                backButtons()
            }
            
            Spacer()
            
            if !hideSpeaker {
                readOutTopCardButton()
            }
            
            /// * this buttons is diffrent from those defined in LearnBottomPassProtocol
            customButton(
                label: isAnswering ? "パス" : (nextCardExist ? "次へ" : "完了"),
                subLabel: "",
                systemName: isAnswering ? "arrowshape.turn.up.right" : "arrowshape.turn.up.right.fill",
                color: isAnswering ? .black : RoyalBlue.defaultRoyal
            ) {
                passAction()
            }
            .padding(.leading, 16)
        }
    }
}
