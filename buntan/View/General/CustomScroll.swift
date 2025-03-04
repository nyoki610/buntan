import SwiftUI

struct CustomScroll<Content: View>: View {
    
    let content: Content
    let paddingBottom: CGFloat
    
    init(@ViewBuilder _ content: () -> Content, paddingBottom: CGFloat = 0) {
        self.content = content()
        self.paddingBottom = paddingBottom
    }
    
    var body: some View {
        
        ScrollView {
            
            VStack {
                content
            }
            .padding(.top, 10)
            .padding(.bottom, paddingBottom)
        }
    }
}
