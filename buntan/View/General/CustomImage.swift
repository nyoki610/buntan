import SwiftUI

struct CustomImage: View {
    
    let image: Img
    let size: CGFloat
    let color: Color
    let label: String
    let subLabel: String?
    
    var body: some View {
        VStack {

            Img.img(image,
                    size: size,
                    color: color)
            
            VStack {
                Text(label)
                if let subLabel = subLabel {
                    Text(subLabel)
                }
            }
            .font(.system(size: size/2))
            .padding(.top, 4)
            .bold()
        }
        .foregroundColor(color)
    }
}
