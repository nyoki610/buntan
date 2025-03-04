import SwiftUI

struct LearnButton: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType: DeviceType

    @EnvironmentObject var alertSharedData: AlertSharedData
    @EnvironmentObject var learnManager: LearnManager
    
    let learnMode: LearnMode?
    let hideSpeaker: Bool
    let isAnswering: Bool
    let nextCardExist: Bool
    let passAction: (() -> Void)
    
    init(learnMode: LearnMode? = nil,
         
         /// for TypeView
         hideSpeaker: Bool = false,
         isAnswering: Bool = false,
         nextCardExist: Bool = false,
         
         /// for SelectView and TypeView
         passAction: @escaping (() -> Void) = {}) {
        self.learnMode = learnMode
        self.hideSpeaker = hideSpeaker
        self.isAnswering = isAnswering
        self.nextCardExist = nextCardExist
        self.passAction = passAction
    }
    
    var body: some View {

        HStack {
            
            if learnMode != nil {
                
                Button {
                    learnManager.backButtonAction()
                } label: {
                    CustomImage(image: .arrowshapeTurnUpLeft,
                                size: responsiveSize(24, 36),
                                color: .black,
                                label: "ひとつ",
                                subLabel: "戻る")
                }
                
                Button {
                    if learnManager.topCardIndex > 0 {
                        alertSharedData.showSelectiveAlert("最初に戻りますか？", "", "最初から", .defaultButton) {
                            while learnManager.topCardIndex > 0 {
                                learnManager.backButtonAction()
                            }
                        }
                    }
                } label: {
                    CustomImage(image: .arrowshapeTurnUpBackward2,
                                size: responsiveSize(24, 36),
                                color: .black,
                                label: "最初に",
                                subLabel: "戻る")
                }
                .padding(.leading, 16)
            }
            
            Spacer()
            
            Button {
                learnManager.readOutTopCard(isButton: true)
            } label: {
                CustomImage(image: .speakerWave2Fill,
                            size: responsiveSize(24, 36),
                            color: learnManager.buttonDisabled ? .gray : .black,
                            label: "音声を",
                            subLabel: "再生")
            }
            .disabled(learnManager.buttonDisabled || hideSpeaker)
            .opacity(hideSpeaker ? 0.0 : 1.0)
            
            if learnMode == .select || learnMode == nil {
                Button {
                    passAction()
                } label: {
                    CustomImage(image: .arrowshapeTurnUpRight,
                                size: responsiveSize(24, 36),
                                color: .black,
                                label: "パス",
                                subLabel: "")
                }
                .padding(.leading, 16)
            }
            
            if learnMode == .type {
                Button {
                    passAction()
                } label: {
                    CustomImage(
                        image: isAnswering ? .arrowshapeTurnUpRight : .arrowshapeTurnUpRightFill,
                        size: responsiveSize(24, 36),
                        color: isAnswering ? .black : RoyalBlue.defaultRoyal,
                        label: isAnswering ? "パス" : (nextCardExist ? "次へ" : "完了"),
                        subLabel: ""
                    )
                }
                .padding(.leading, 16)
            }
        }
        .padding(.horizontal, responsiveSize(50, 140))
        .padding(.bottom, responsiveSize(10, 30))
    }
}
