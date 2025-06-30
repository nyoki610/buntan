//import SwiftUI
//
//struct LearnButton: ResponsiveView {
//    
//    @Environment(\.deviceType) var deviceType: DeviceType
//
//    @EnvironmentObject var alertSharedData: AlertSharedData
//    @EnvironmentObject var learnManager: LearnManager
//    
//    let learnMode: LearnMode?
//    let hideSpeaker: Bool
//    let isAnswering: Bool
//    let nextCardExist: Bool
//    let passAction: (() -> Void)
//    
//    init(learnMode: LearnMode? = nil,
//         
//         /// for TypeView
//         hideSpeaker: Bool = false,
//         isAnswering: Bool = false,
//         nextCardExist: Bool = false,
//         
//         /// for SelectView and TypeView
//         passAction: @escaping (() -> Void) = {}) {
//        
//        self.learnMode = learnMode
//        self.hideSpeaker = hideSpeaker
//        self.isAnswering = isAnswering
//        self.nextCardExist = nextCardExist
//        self.passAction = passAction
//    }
//    
//    var body: some View {
//
//        HStack {
//            
//            if learnMode != nil && learnManager.topCardIndex > 0 {
//                
//                customButton(label: "ひとつ",
//                             subLabel: "戻る",
//                             systemName: "arrowshape.turn.up.left") {
//                    learnManager.backButtonAction()
//                }
//                          
//                customButton(label: "最初に",
//                             subLabel: "戻る",
//                             systemName: "arrowshape.turn.up.backward.2") {
//                    backToStart()
//                }
//                .padding(.leading, 16)
//            }
//            
//            Spacer()
//            
//            customButton(label: "音声を",
//                         subLabel: "再生",
//                         systemName: "speaker.wave.2.fill",
//                         color: learnManager.buttonDisabled ? .gray : .black) {
////                learnManager.readOutTopCard(isButton: true)
//            }
//            .disabled(learnManager.buttonDisabled || hideSpeaker)
//            .opacity(hideSpeaker ? 0.0 : 1.0)
//            
//            if learnMode == .select || learnMode == nil {
//                
//                // 連打を防がなくても良い?
//                customButton(label: "パス",
//                             subLabel: "",
//                             systemName: "arrowshape.turn.up.right") {
//                    passAction()
//                }
//                .padding(.leading, 16)
//            }
//            
//            if learnMode == .type {
//                customButton(
//                    label: isAnswering ? "パス" : (nextCardExist ? "次へ" : "完了"),
//                    subLabel: "",
//                    systemName: isAnswering ? "arrowshape.turn.up.right" : "arrowshape.turn.up.right.fill",
//                    color: isAnswering ? .black : RoyalBlue.defaultRoyal
//                ) {
//                    passAction()
//                }
//                .padding(.leading, 16)
//            }
//        }
//        .padding(.horizontal, responsiveSize(50, 140))
//        .padding(.bottom, responsiveSize(10, 30))
//    }
//    
//    @ViewBuilder
//    private func customButton(
//        label: String,
//        subLabel: String,
//        systemName: String,
//        color: Color = .black,
//        action: @escaping () -> Void = {}
//    ) -> some View {
//        
//        let size = responsiveSize(24, 36)
//        
//        Button(action: action) {
//            
//            VStack {
//                
//                Image(systemName: systemName)
//                    .font(.system(size: size))
//                
//                VStack {
//                    Text(label)
//                    Text(subLabel)
//                }
//                .font(.system(size: size/2))
//                .padding(.top, 4)
//            }
//            .fontWeight(.bold)
//            .foregroundStyle(color)
//        }
//    }
//    
//    private func backToStart() -> Void {
//        
//        if learnManager.topCardIndex > 0 {
//            alertSharedData.showSelectiveAlert(
//                title: "最初に戻りますか？",
//                message: "",
//                secondaryButtonLabel: "最初から",
//                secondaryButtonType: .defaultButton
//            ) {
//                while learnManager.topCardIndex > 0 {
//                    learnManager.backButtonAction()
//                }
//            }
//        }
//    }
//}
