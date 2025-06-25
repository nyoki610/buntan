import SwiftUI


struct BookLearnSettingButtons: LearnSettingButtonsProtocol {
    
    @Environment(\.deviceType) var deviceType: DeviceType
    
    @ObservedObject var userDefaultHandler: LearnUserDefaultHandler

    private let learnMode: LearnMode

    @Binding internal var showSetting: Bool

    private let shuffleAction: () -> Void
    
    init(
        userDefaultHandler: LearnUserDefaultHandler,
        learnMode: LearnMode,
        showSetting: Binding<Bool>,
        shuffleAction: @escaping () -> Void
    ) {
        self.userDefaultHandler = userDefaultHandler
        self.learnMode = learnMode
        self._showSetting = showSetting
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
                _LearnSettingToggleButton(
                    label: "シャッフル",
                    subLabel: nil,
                    systemName: "shuffle",
                    targetBool: $userDefaultHandler.shouldShuffle) {
                        shuffleAction()
                    }
                
                Spacer()
                _LearnSettingToggleButton(
                    label: "音声を",
                    subLabel: "自動再生",
                    systemName: "speaker.wave.2.fill",
                    targetBool: $userDefaultHandler.shouldReadOut
                )
                Spacer()
                
                switch learnMode {
                case .swipe, .select:
                    _LearnSettingToggleButton(
                        label: "例文を",
                        subLabel: "表示",
                        systemName: "textformat.abc",
                        targetBool: $userDefaultHandler.showSentence
                    )
                case .type:
                    _LearnSettingToggleButton(
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
}
