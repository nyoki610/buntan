import SwiftUI
import AudioToolbox

@MainActor
class LoadingManager: ObservableObject {

    @Published private(set) var loadingStatus: Status?
    
    enum Status {
        case loading(label: String)
        case completed
    }
    
    enum LoadingType: String {
        case process = "処理中..."
        case save = "保存中..."
    }

    internal func startLoading(_ type: LoadingType) async {
        
        self.loadingStatus = .loading(label: type.rawValue)
    }
    
    internal func showCompletion() async {
        
        guard case .loading = loadingStatus else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            self.loadingStatus = .completed
        }
        
        let delay: UInt64 = 800_000_000
        try? await Task.sleep(nanoseconds: delay)
    }
    
    internal func finishLoading() async {

        let delay: UInt64 = 300_000_000
        try? await Task.sleep(nanoseconds: delay)

        self.loadingStatus = nil
    }
}
