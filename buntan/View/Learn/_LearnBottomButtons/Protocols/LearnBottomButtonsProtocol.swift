import SwiftUI


protocol LearnBottomButtonsProtocol: ResponsiveView {
    
    var deviceType: DeviceType { get }
}


extension LearnBottomButtonsProtocol {
    
    @ViewBuilder
    func customButton(
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
}
