import SwiftUI

struct PhantomHStack<Content: View>: View {
    
    let content: Content
    let targetBool: Bool
    let height: CGFloat
    
    init(targetBool: Bool, @ViewBuilder _ content: () -> Content, height: CGFloat) {
        self.targetBool = targetBool
        self.content = content()
        self.height = height
    }
    
    var body: some View {
        HStack {
            Spacer()
            /// ガイドは常に表示したほうがよさそう?
            ///if targetBool {
                content
            ///}
            Spacer()
        }
        .frame(height: height)
    }
}
