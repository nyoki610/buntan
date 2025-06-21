import SwiftUI

class BookSharedData: ObservableObject {
    
    @Published var path: [ViewName] = []
    
    @Published var booksDict: [EikenGrade: [BookConfiguration: Book]] = [:]

    var selectedGrade: EikenGrade = .first
    var selectedBookConfig: BookConfiguration = .frequency(.freqA)
    var selectedSectionTitle: String = ""
    
    var selectedGradeBookDict: [BookConfiguration: Book] {
        booksDict[selectedGrade] ?? [:]
    }
    
    var selectedBookCategory: BookCategory = .freq
    
    var selectedBook: Book {
        selectedGradeBookDict[selectedBookConfig] ?? EmptyModel.book
    }
    
    var selectedSection: Section {
        selectedBook.sections.filter { $0.title == selectedSectionTitle }.first ?? EmptyModel.section
    }
    
    @Published var selectedMode: LearnMode = .swipe
    @Published var selectedRange: LearnRange = .notLearned
    
    @Published var cardsContainer: [[Card]] = [[], [], []]
    var cards: [Card] { cardsContainer[selectedRange.rawValue] }
    var options: [[Option]] = []
    
    func setupBooksDict(_ booksDict: [EikenGrade: [BookConfiguration: Book]]) {
        self.booksDict = booksDict
        arrangeContainer()
    }
    
    /// selectedSection.cards を　未学習の単語・学習中の単語・すべての単語　に分類して cardsContainer に格納
    func arrangeContainer() {

        cardsContainer[LearnRange.all.rawValue] = selectedSection.cards
        cardsContainer[LearnRange.notLearned.rawValue] = selectedSection.cards.filter { $0.status(selectedBook.bookCategory) == .notLearned}
        cardsContainer[LearnRange.learning.rawValue] = selectedSection.cards.filter { $0.status(selectedBook.bookCategory) == .learning }
        
        for (index, _) in cardsContainer.enumerated() {
            cardsContainer[index].sort { $0.word < $1.word }
        }
        
        adjustSelectedRange()
    }
    
    
    /// ユーザーの学習状況に応じて selectedRange の初期値を設定
    func adjustSelectedRange() {
        
        selectedRange = .notLearned
        
        if cardsContainer[LearnRange.notLearned.rawValue].count == 0 {
            selectedRange = .learning
            
            if cardsContainer[LearnRange.learning.rawValue].count == 0 {
                selectedRange = .all
            }
        }
    }
}

