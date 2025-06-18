import Foundation
import FirebaseAnalytics

struct AnalyticsManager {
    static func logButtonTap(buttonName: String) {
        Analytics.logEvent("button_tap", parameters: [
            "button_name": buttonName
        ])
    }
    
    static func logScreenView(screenName: String) {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: screenName,
            AnalyticsParameterScreenClass: screenName
        ])
    }
}