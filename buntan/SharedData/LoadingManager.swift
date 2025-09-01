import SwiftUI
import AudioToolbox

@MainActor
class LoadingManager: ObservableObject {

    @Published private(set) var loadingStatus: Status?
    
    enum Status {
        case loading(label: String)
        case completed
    }
    
    enum LoadingType: Equatable {
        case fetch
        case process
        case save
        case custom(message: String)
        
        var message: String {
            switch self {
            case .fetch: return "データ取得中..."
            case .process: return "処理中..."
            case .save: return "保存中..."
            case .custom(let message): return message
            }
        }
    }
    
    internal func startLoading(_ type: LoadingType) async {
        
        self.loadingStatus = .loading(label: type.message)
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
