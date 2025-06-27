import SwiftUI


struct BookLearnSettingButtons: LearnSettingButtonsProtocol {
    
    @Environment(\.deviceType) var deviceType: DeviceType
    
    @EnvironmentObject var alertSharedData: AlertSharedData
    
    @ObservedObject var userDefaultHandler: LearnUserDefaultHandler

    private let learnMode: LearnMode

    @Binding internal var showSetting: Bool
    
    private let isInitialState: Bool
    
    private let shuffleAction: () -> Void
    
    init(
        userDefaultHandler: LearnUserDefaultHandler,
        learnMode: LearnMode,
        showSetting: Binding<Bool>,
        isInitialState: Bool,
        shuffleAction: @escaping () -> Void
    ) {
        self.userDefaultHandler = userDefaultHandler
        self.learnMode = learnMode
        self._showSetting = showSetting
        self.isInitialState = isInitialState
        self.shuffleAction = shuffleAction
    }
    
    var body: some View {
        
        toggleButtonsFrame {
            withAnimation(.easeOut(duration: 0.2)) {
                showSetting = true
            }
        } content: {
            
            HStack {
                Spacer()
                toggleButton(
                    label: "シャッフル",
                    subLabel: nil,
                    systemName: "shuffle",
                    targetBool: $userDefaultHandler.shouldShuffle) {
                        confirmShuffle {
                            userDefaultHandler.shouldShuffle.toggle()
                            shuffleAction()
                        }
                    }
                
                Spacer()
                toggleButton(
                    label: "音声を",
                    subLabel: "自動再生",
                    systemName: "speaker.wave.2.fill",
                    targetBool: $userDefaultHandler.shouldReadOut
                )
                Spacer()
                
                switch learnMode {
                case .swipe, .select:
                    toggleButton(
                        label: "例文を",
                        subLabel: "表示",
                        systemName: "textformat.abc",
                        targetBool: $userDefaultHandler.showSentence
                    )
                case .type:
                    toggleButton(
                        label: "イニシャルを",
                        subLabel: "表示",
                        systemName: "character",
                        targetBool: $userDefaultHandler.showInitial
                    )
                }
                Spacer()
            }
            .padding(.top, 10)
        }
    }
    
    private func confirmShuffle(shuffleAction: @escaping () -> Void) -> Void {
        
        if isInitialState {
            shuffleAction()
        } else {
            var title = "現在の進捗はリセットされます\n"
            title += userDefaultHandler.shouldShuffle ? "元に戻" : "シャッフル"
            title += "しますか？"
            
            let secondaryButtonLabel = userDefaultHandler.shouldShuffle ? "元に戻す" : "シャッフル"
            
            alertSharedData.showSelectiveAlert(
                title: title,
                message: "",
                secondaryButtonLabel: secondaryButtonLabel,
                secondaryButtonType: .defaultButton
            ) {
                shuffleAction()
            }
        }
    }
}

