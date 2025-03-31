import SwiftUI


extension View {
    func fontSize(_ size: CGFloat) -> some View {
        self.font(.system(size: size))
    }
}
