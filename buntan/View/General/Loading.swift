import SwiftUI

struct Loading: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType: DeviceType

    let loadingLabel: String
    var isCompleted: Bool = false

    var body: some View {
            
        VStack {
            
            if !isCompleted {
                
                ProgressView()
                    .scaleEffect(responsiveSize(1.5, 2.0))
                    .frame(maxWidth: .infinity)
                    .padding(.top, 10)
                
                Text(loadingLabel)
                    .fontSize(responsiveSize(14, 20))
                    .bold()
                    .padding(.top, responsiveSize(10, 32))
                
            } else {
                
                Spacer()

                Image(systemName: "checkmark.circle")
                    .font(.system(size: responsiveSize(60, 100)))
                    .foregroundColor(.green.opacity(0.5))
                    
                .frame(maxWidth: .infinity)
                
                Spacer()
            }
                
        }
        .padding()
        .frame(width: responsiveSize(140, 200), height: responsiveSize(100, 160))
        .background(.white)
        .cornerRadius(10)
    }
}
