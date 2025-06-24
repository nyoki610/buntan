import SwiftUI


struct BookLearnHeader: ResponsiveView, LearnShuffleProtocol {
    
    @Environment(\.deviceType) var deviceType: DeviceType
    
    @EnvironmentObject var alertSharedData: AlertSharedData
    
    @ObservedObject var userDefaultHandler: LearnUserDefaultHandler
    @ObservedObject var learnManager: BookLearnManager
    
    let geometry: GeometryProxy
    let learnMode: LearnMode?
    
    private var isTypeView: Bool { learnMode == .type }
    
    let saveAction: () -> Void
    
    init(
        learnManager: BookLearnManager,
        userDefaultHandler: LearnUserDefaultHandler,
        geometry: GeometryProxy,
        learnMode: LearnMode?,
        saveAction: @escaping () -> Void
    ) {
        self.learnManager = learnManager
        self.userDefaultHandler = userDefaultHandler
        self.geometry = geometry
        self.learnMode = learnMode
        self.saveAction = saveAction
    }
    
    var body: some View {
        
        VStack {
            
            _LearnHeader(learnManager: learnManager as _LearnManager,
                         geometry: geometry) {
                saveAction()
            }
            
            if learnManager.showSettings {
                settingButtons
            } else {
                showSettingButton
            }
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

            _LearnSettingToggleButton(
                label: isTypeView ? "イニシャルを" : "例文を",
                subLabel: "表示",
                systemName: isTypeView ? "character" : "textformat.abc",
                targetBool: isTypeView ? $userDefaultHandler.showInitial : $userDefaultHandler.showSentence
            )
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
                    learnManager.showSettings = true
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
