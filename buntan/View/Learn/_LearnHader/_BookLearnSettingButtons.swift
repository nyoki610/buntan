import SwiftUI


struct LearnSettingButtons: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType: DeviceType
    
    @ObservedObject var userDefaultHandler: LearnUserDefaultHandler

    private let learnMode: LearnMode

    @Binding private var showSetting: Bool

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
        
        if showSetting {
            settingButtons
        } else {
            showSettingButton
        }
    }
    
    @ViewBuilder
    private var settingButtons: some View {
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
    
    @ViewBuilder
    private var showSettingButton: some View {
        
        HStack {
            Spacer()
            Button {
                withAnimation(.easeOut(duration: 0.2)) {
                    showSetting = true
                }
            } label: {
                HStack {
                    Image(systemName: "chevron.down")
                    Text("設定を表示")
                }
                .font(.system(size: responsiveSize(16, 24)))
                .fontWeight(.bold)
                .foregroundStyle(.black.opacity(0.8))
            }
        }
        .padding(.top, 10)
        .padding(.horizontal, responsiveSize(20, 40))
    }
}
