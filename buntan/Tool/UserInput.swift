import Foundation

class UserInput: ObservableObject {}

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

extension BookUserInput {
    enum Error: Swift.Error {
        case valueIsNil(keyPath: String)
    }
    
    func require<Value>(
        _ keyPath: KeyPath<BookUserInput, Value?>,
        keyPathName: String = #function
    ) throws -> Value {
        guard let value = self[keyPath: keyPath] else {
            throw Error.valueIsNil(keyPath: keyPathName)
        }
        return value
    }
}

final class CheckUserInput: UserInput {
    @Published var selectedGrade: EikenGrade = .first
}
