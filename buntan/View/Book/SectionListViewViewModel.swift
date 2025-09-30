import Foundation

class SectionListViewViewModel: ObservableObject {
    
    @Published var book: Book
    
    /// realm読み込み中にViewの表示を変更するための変数
    /// realmの読み込みが高速のため, 現時点では未使用
    @Published var isFetchingUpdatedBook: Bool = false
    private var shouldCallOnAppearAction: Bool = false
    
    init(book: Book) {
        self.book = book
    }
    
    internal func onAppearAction(userInput: BookUserInput) {
        if shouldCallOnAppearAction {
            updateBook(userInput: userInput)
        } else {
            shouldCallOnAppearAction = true
        }
    }
    
    private func updateBook(userInput: BookUserInput) {
        
        isFetchingUpdatedBook = true
        
        guard let selectedGrade = userInput.selectedGrade,
              let selectedBookCategory = userInput.selectedBookCategory,
              let selectedBookConfig = userInput.selectedBookConfig else {
            return
        }
        let bookUseCase = BookUseCase()
        guard let updatedBook = try? bookUseCase.getBook(
            for: selectedGrade,
            category: selectedBookCategory,
            config: selectedBookConfig
        ) else { return }
        
        book = updatedBook
        isFetchingUpdatedBook = false
    }
}
