import SwiftUI

struct XmarkHeader: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType: DeviceType
    let action: () -> Void
    
    var body: some View {
        
        HStack {
         
            Button {
                action()
            } label: {
                Img.img(.xmark,
                        size: responsiveSize(18, 24),
                        color: .black)
            }
            
            Spacer()
                
        }
        .padding(.top, 20)
        .padding(.horizontal, 30)
    }
}

