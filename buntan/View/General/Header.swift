import SwiftUI

struct Header: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType: DeviceType
    
    let title: String?
    @Binding var path: [ViewName]
    
    init(path: Binding<[ViewName]>, title: String? = nil) {
        _path = path
        self.title = title
    }
    
    var body: some View {
        
        ZStack {
            if let title = title {
                Text(title)
                    .bold()
                    .font(.system(size: responsiveSize(18, 24)))
            }
            
            HStack {
                Button {
                    guard path.count != 0 else { return }
                    path.removeLast()
                } label: {
                    Image(systemName: "arrowshape.turn.up.left")
                        .font(.system(size: responsiveSize(18, 24)))
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                }
                Spacer()
            }
        }
        .padding(.vertical, responsiveSize(20, 40))
        .padding(.horizontal, 30)
    }
}
