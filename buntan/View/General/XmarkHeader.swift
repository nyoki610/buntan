import SwiftUI

struct XmarkHeader: View {

    let action: () -> Void
    
    var body: some View {
        
        HStack {
         
            Button {
                action()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: responsiveSize(18, 24)))
                    .foregroundColor(.black)
                    .fontWeight(.bold)
            }
            
            Spacer()
                
        }
        .padding(.top, 20)
        .padding(.horizontal, 30)
    }
}

