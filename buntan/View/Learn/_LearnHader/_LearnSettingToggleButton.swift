import SwiftUI


struct _LearnSettingToggleButton: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType: DeviceType
    
    private let label: String
    private let subLabel: String?
    private let systemName: String
    private let targetBool: Binding<Bool>
    private var action: (() -> Void)?
    
    private var size: CGFloat { responsiveSize(20, 28) }
    private var labelSize: CGFloat { size / 1.8 }

    init(label: String, subLabel: String?, systemName: String, targetBool: Binding<Bool>, action: (() -> Void)? = nil) {
        self.label = label
        self.subLabel = subLabel
        self.systemName = systemName
        self.targetBool = targetBool
        self.action = action
    }
    
    var body: some View {
        
        HStack {
            
            VStack {

                Image(systemName: systemName)
                    .font(.system(size: size))
                    
                VStack {
                    Text(label)
                    if let subLabel = subLabel {
                        Text(subLabel)
                    }
                }
                .font(.system(size: labelSize))
                .padding(.top, 4)
            }
            .foregroundStyle(.black)
            .fontWeight(.bold)
            .padding(.trailing, 4)
            
            CustomToggle(
                isOn: targetBool,
                color: Orange.egg,
                scale: responsiveSize(1.0, 1.3),
                action: action
            )
        }
        .offset(x: -5)
    }
}
