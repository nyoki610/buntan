import SwiftUI
import FirebaseAnalytics

struct ScreenLogger: ViewModifier {
    
    let screenName: String
    let screenClass: String
    
    @State private var hasLogged = false
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                guard !hasLogged else { return }
                
                Analytics.logEvent(AnalyticsEventScreenView, parameters: [
                    AnalyticsParameterScreenName: screenName,
                    AnalyticsParameterScreenClass: screenClass
                ])
                
                hasLogged = true
            }
    }
}

extension View {
    func logScreenView(name: String, class: String) -> some View {
        self.modifier(ScreenLogger(screenName: name, screenClass: `class`))
    }
} 