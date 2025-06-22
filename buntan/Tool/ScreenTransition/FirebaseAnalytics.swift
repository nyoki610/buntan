import Foundation
import FirebaseAnalytics


enum AnalyticsHandler {
    
    static func logScreenTransition(viewName: ViewName) {
        
        Analytics.logEvent(
            AnalyticsEventScreenView,
            parameters: [
                AnalyticsParameterScreenName: viewName.screenName,
                AnalyticsParameterScreenClass: viewName.screenClassName
            ]
        )
    }
}
