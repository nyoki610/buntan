import SwiftUI


protocol LearnSettingButtonsProtocol: ResponsiveView {
    
    var showSetting: Bool { get set }
}


extension LearnSettingButtonsProtocol {
    
    @ViewBuilder
    internal func toggleButtonsFrame<Content: View>(
        showSettingAction: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) -> some View {
        
        if showSetting {
            content()
        } else {
            showSettingButton {
                showSettingAction()
            }
        }
    }
    
    @ViewBuilder
    private func showSettingButton(showSettingAction: @escaping () -> Void) -> some View {
        
        HStack {
            Spacer()
            Button {
                showSettingAction()
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


extension LearnSettingButtonsProtocol {
    
    var size: CGFloat { responsiveSize(20, 28) }
    var labelSize: CGFloat { size / 1.8 }
    
    @ViewBuilder
    internal func toggleButton(
        label: String,
        subLabel: String?,
        systemName: String,
        targetBool: Binding<Bool>,
        action: (() -> Void)? = nil
    ) -> some View {
        
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
