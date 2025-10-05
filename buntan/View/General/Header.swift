import SwiftUI

struct Header<NavigatorType: Navigating>: View {


    let title: String?

    private let navigator: NavigatorType
    
    init(navigator: NavigatorType, title: String? = nil) {
        self.navigator = navigator
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
                    navigator.pop(count: 1)
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
