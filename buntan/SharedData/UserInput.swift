import Foundation

class UserInput: ObservableObject {
    
}

final class BookUserInput: UserInput {
    
    var selectedGrade: EikenGrade?
    var selectedBookConfig: BookConfiguration?
    var selectedSectionTitle: String?
    var selectedBookCategory: BookCategory?
    
    @Published var selectedMode: LearnMode = .swipe
    @Published var selectedRange: LearnRange = .notLearned
    
    /// 将来的に削除したい？
    @Published var todaysWordCount: Int?
}

final class CheckUserInput: UserInput {
    @Published var selectedGrade: EikenGrade = .first
}
