import SwiftUI
import FirebaseAnalytics

struct AnalyticsViewModifier: ViewModifier {

    let screenName: String
    let screenClass: String

    init(viewName: ViewName) {
        self.screenName = viewName.rawValue
        self.screenClass = viewName.screenClassName
    }

    func body(content: Content) -> some View {
        content
            .onAppear {
                Analytics.logEvent(AnalyticsEventScreenView, parameters: [
                    AnalyticsParameterScreenName: screenName,
                    AnalyticsParameterScreenClass: screenClass
                ])
            }
    }
}

extension View {
    func trackScreenView(viewName: ViewName) -> some View {
        self.modifier(AnalyticsViewModifier(viewName: viewName))
    }
}