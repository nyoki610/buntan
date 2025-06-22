import SwiftUI

class BookSharedData: ObservableObject {
    
    @Published var booksDict: [EikenGrade: [BookConfiguration: Book]] = [:]

    var selectedGrade: EikenGrade = .first
    var selectedBookConfig: BookConfiguration = .frequency(.freqA)
    var selectedSectionTitle: String = ""
    var selectedBookCategory: BookCategory = .freq
    
    @Published var selectedMode: LearnMode = .swipe
    @Published var selectedRange: LearnRange = .notLearned

    var options: [[Option]] = []
    
    func setupBooksDict(_ booksDict: [EikenGrade: [BookConfiguration: Book]]) {
        self.booksDict = booksDict
    }
}

