import SwiftUI

struct CustomToggle: View {
    
    @Binding var isOn: Bool
    let color: Color
    let scale: CGFloat
    let action: (() -> Void)?
    
    var body: some View {
        Button {
            guard let action = action else { isOn.toggle(); return }
            action()
        } label: {
            ZStack {
                
                RoundedRectangle(cornerRadius: 16 * scale)
                    .fill(isOn ? color : .gray.opacity(0.3))
                    .frame(width: 50 * scale, height: 30 * scale)
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 26 * scale, height: 26 * scale)
                    .offset(x: isOn ? 10 * scale : -10 * scale)
                    .animation(.easeInOut(duration: 0.2), value: isOn)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
