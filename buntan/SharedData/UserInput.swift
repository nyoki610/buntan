import Foundation

class UserInput: ObservableObject {
    
}

final class BookUserInput: UserInput {
    
    var selectedGrade: EikenGrade?
    var selectedBookConfig: BookConfiguration?
    var selectedSectionTitle: String?
    var selectedBookCategory: BookCategory?
    
    @Published var selectedMode: LearnMode?
    @Published var selectedRange: LearnRange?
}

final class CheckUserInput: UserInput {
    var selectedGrade: EikenGrade = .first
}
