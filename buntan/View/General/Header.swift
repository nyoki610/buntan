import SwiftUI

struct Header<PathHandlerType: PathHandlerProtocol>: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType: DeviceType

    let title: String?

    @ObservedObject private var pathHandler: PathHandlerType
    
    init(pathHandler: PathHandlerType, title: String? = nil) {
        self._pathHandler = ObservedObject(wrappedValue: pathHandler)
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
                    pathHandler.backToPreviousScreen(count: 1)
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
