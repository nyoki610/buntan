import SwiftUI

class LoadingSharedData: ObservableObject {
    
    /// Loading をコントロール
    var loadingType: LoadingType?
    @Published var isLoading: Bool = false
    @Published var isCompleted: Bool = false
    ///
    
    /// LoadingView() を表示
    func loadingView() -> some View {
        
        return Loading(loadingLabel: loadingType?.label ?? "",
                       isCompleted: isCompleted)
    }
    
    /// Loading を開始
    func startLoading(_ type: LoadingType) {
        
        DispatchQueue.main.async {
            self.loadingType = type
            self.isLoading = true
        }
    }
    
    /// Loading を終了
    func finishLoading(_ showCompletion: Bool = false, completion: @escaping () -> Void) {
        
        if showCompletion {
            self.isCompleted = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            DispatchQueue.main.async {
                self.loadingType = nil
                self.isLoading = false
                self.isCompleted = false
            }
            
            completion()
        }
    }
    
    enum LoadingType {
        case process
        case save
        
        var label: String {
            switch self {
            case .process: return "処理中..."
            case .save: return "保存中..."
            }
        }
    }
}
