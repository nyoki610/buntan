import SwiftUI

/// added at 2025/01/22 for Firebase Analytics
import FirebaseCore
///


/// added at 2025/01/22 for Firebase Analytics
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
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
                .environment(\.deviceType, DeviceType.model)
        }
    }
}
