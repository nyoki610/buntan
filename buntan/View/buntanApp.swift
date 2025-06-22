import SwiftUI

/// added at 2025/01/22 for Firebase Analytics
import FirebaseCore
import Firebase
///


/// added at 2025/01/22 for Firebase Analytics
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//      FirebaseConfiguration.shared.setLoggerLevel(.error)
      FirebaseApp.configure()
      Analytics.setAnalyticsCollectionEnabled(true)
    return true
  }
}
///


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
                .environment(\.deviceType, DeviceType.model)
        }
    }
}
