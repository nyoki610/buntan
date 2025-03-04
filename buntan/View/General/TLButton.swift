import SwiftUI

struct TLButton: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType: DeviceType
    let title: String
    let textColor: Color
    let background: Color
    var image: Img?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                
                Text(title)
                
                if let image = image {
                    Img.img(image, color: .white)
                }
            }
            .font(.system(size: responsiveSize(16, 20)))
            .fontWeight(.bold)
            .foregroundColor(textColor)
            .frame(height: responsiveSize(36, 48))
            .padding(.horizontal, responsiveSize(20, 30))
            .background(RoundedRectangle(cornerRadius: 5).foregroundColor(background))
        }
    }
}
