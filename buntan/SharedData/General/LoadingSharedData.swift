import SwiftUI

class LoadingSharedData: ObservableObject {
    
    /// 以下の３変数は"キャンセル" or "完了"時に init
    /// controllCustomAlert 実行時に true
    // @Published var animationController: Bool = false
    // @Published var showCustomAlert: Bool = false
    /// ユーザーの入力内容を保持
    // @Published var userInput: String = ""
    
    /// Loading をコントロール
    var loadingType: LoadingType?
    @Published var isLoading: Bool = false
    @Published var isCompleted: Bool = false
    ///
    
    func loadingView() -> some View {
        
        return Loading(loadingLabel: loadingType?.label ?? "",
                       isCompleted: isCompleted)
    }
    
    func startLoading(_ type: LoadingType) {
        
        DispatchQueue.main.async {
            self.loadingType = type
            self.isLoading = true
        }
    }
    
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
