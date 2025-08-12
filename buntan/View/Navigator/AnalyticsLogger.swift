import Foundation
import FirebaseAnalytics


enum AnalyticsLogger {
    
    static func logScreenTransition(viewName: any ViewNameProtocol) {
        
        Analytics.logEvent(
            AnalyticsEventScreenView,
            parameters: [
                AnalyticsParameterScreenName: viewName.screenName,
                AnalyticsParameterScreenClass: viewName.screenClassName
            ]
        )
    }
}
