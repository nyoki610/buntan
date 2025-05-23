import SwiftUI

struct StartButton: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType: DeviceType
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button (action: action) {
            HStack {
                Spacer()
                Text("学習を開始 →")
                Spacer()
            }
            .font(.system(size: responsiveSize(16, 20)))
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(width: responsiveSize(160, 180), height: responsiveSize(36, 48))
            .padding(.horizontal, responsiveSize(20, 30))
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(Orange.defaultOrange)
                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
            )
        }
    }
}
