import SwiftUI


protocol LearnBottomButtonsProtocol: ResponsiveView {
    
    var deviceType: DeviceType { get }
    var learnManager: _LearnManager { get }
}


extension LearnBottomButtonsProtocol {
    
    @ViewBuilder
    internal func bottomButtonsFrame<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        
        HStack {
            content()
        }
        .padding(.horizontal, responsiveSize(50, 140))
        .padding(.bottom, responsiveSize(10, 30))
    }
    
    @ViewBuilder
    internal func customButton(
        label: String,
        subLabel: String,
        systemName: String,
        color: Color = .black,
        action: @escaping () -> Void = {}
    ) -> some View {
        
        let size = responsiveSize(24, 36)
        
        Button(action: action) {
            
            VStack {
                
                Image(systemName: systemName)
                    .font(.system(size: size))
                
                VStack {
                    Text(label)
                    Text(subLabel)
                }
                .font(.system(size: size/2))
                .padding(.top, 4)
            }
            .fontWeight(.bold)
            .foregroundStyle(color)
        }
    }
    
    internal func readOutTopCardButton() -> some View {
        
        customButton(label: "音声を",
                     subLabel: "再生",
                     systemName: "speaker.wave.2.fill",
                     color: learnManager.buttonDisabled ? .gray : .black) {
            learnManager.readOutTopCard(
                isButton: true,
                shouldReadOut: true
            )
        }
        .disabled(learnManager.buttonDisabled)
    }
}
