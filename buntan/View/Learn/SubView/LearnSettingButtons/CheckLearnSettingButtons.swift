import SwiftUI


struct CheckLearnSettingButtons: LearnSettingButtonsProtocol {
    
    @Environment(\.deviceType) var deviceType: DeviceType
    
    @ObservedObject var userDefaultHandler: LearnUserDefaultHandler
    
    @Binding internal var showSetting: Bool
    
    init(
        userDefaultHandler: LearnUserDefaultHandler,
        showSetting: Binding<Bool>
    ) {
        self.userDefaultHandler = userDefaultHandler
        self._showSetting = showSetting
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
                    label: "音声を",
                    subLabel: "自動再生",
                    systemName: "speaker.wave.2.fill",
                    targetBool: $userDefaultHandler.shouldReadOut
                )
                Spacer()
            }
            .padding(.top, 10)
        }
    }
}
