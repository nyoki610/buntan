import SwiftUI

class BookSharedData: ObservableObject {
    
    @Published var path: [ViewName] = []
    
    @Published var booksDict: [Eiken: [BookDesign: Book]] = [:]

    var selectedGrade: Eiken = .first
    var selectedBookDesign: BookDesign = .freqA
    var selectedSectionId: String = ""
    
    var selectedGradeBookDict: [BookDesign: Book] {
        booksDict[selectedGrade] ?? [:]
    }
    
    var selectedBookType: BookType = .freq
    
    var selectedBook: Book {
        selectedGradeBookDict[selectedBookDesign] ?? EmptyModel.book
    }
    
    var selectedSection: Section {
        selectedBook.sections.filter { $0.id == selectedSectionId }.first ?? EmptyModel.section
    }
    
    @Published var selectedMode: LearnMode = .swipe
    @Published var selectedRange: LearnRange = .notLearned
    
    @Published var cardsContainer: [[Card]] = [[], [], []]
    var cards: [Card] { cardsContainer[selectedRange.rawValue] }
    var options: [[Option]] = []
    
    func setupBooksDict(_ booksDict: [Eiken: [BookDesign: Book]]) {
        self.booksDict = booksDict
        arrangeContainer()
    }
    
    /// selectedSection.cards を　未学習の単語・学習中の単語・すべての単語　に分類して cardsContainer に格納
    func arrangeContainer() {

        cardsContainer[LearnRange.all.rawValue] = selectedSection.cards
        cardsContainer[LearnRange.notLearned.rawValue] = selectedSection.cards.filter { $0.status(selectedBook.bookType) == .notLearned}
        cardsContainer[LearnRange.learning.rawValue] = selectedSection.cards.filter { $0.status(selectedBook.bookType) == .learning }
        
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

