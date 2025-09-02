import SwiftUI

/// added at 2025/01/22 for Firebase Analytics
import FirebaseCore
import Firebase


class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        setupFirebase()
        
        return true
    }
    
    private func setupFirebase() {
        
        FirebaseConfiguration.shared.setLoggerLevel(.error)
        FirebaseApp.configure()
        Analytics.setAnalyticsCollectionEnabled(analyticsEnabled)
    }
    
    private var analyticsEnabled: Bool {
        var enabled = true
        #if DEBUG
        enabled = false
        #endif
        return enabled
    }
}


@main
struct buntanApp: App {

    /// added at 2025/01/22 for Firebase Analytics
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    ///

    var body: some Scene {
        WindowGroup {
            MainView()
                /// default font size
                .font(.system(size: 17))
        }
    }
}
