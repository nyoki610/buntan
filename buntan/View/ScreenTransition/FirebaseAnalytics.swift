import Foundation
import FirebaseAnalytics


enum AnalyticsHandler {
    
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
