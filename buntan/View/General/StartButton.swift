import SwiftUI

struct StartButton: View {

    let label: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button (action: action) {
            HStack {
                Text(label)
                    .font(.system(size: responsiveSize(18, 22)))
                    .fontWeight(.heavy)
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, responsiveSize(40, 60))
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(color)
                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
            )
        }
    }
}
