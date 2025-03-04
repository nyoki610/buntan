import SwiftUI

class BookSharedData: ObservableObject {
    
    @Published var path: [ViewName] = []
    
    @Published var booksList: [[Book]] = []

    var selectedGrade: Eiken = .first
    var selectedBookDesign: BookDesign = .freqA
    var selectedSectionId: String = ""
    
    var selectedBooks: [Book] {
        booksList.indices.contains(selectedGrade.index) ? booksList[selectedGrade.index] : []
    }
    
    var selectedBook: Book {
        selectedBooks.first(where: { $0.id == selectedBookDesign }) ?? EmptyModel.book
    }
    
    var selectedSection: Section {
        selectedBook.sections.filter { $0.id == selectedSectionId }.first ?? EmptyModel.section
    }
    
    @Published var selectedMode: LearnMode = .swipe
    @Published var selectedRange: LearnRange = .notLearned
    
    @Published var cardsContainer: [[Card]] = [[], [], []]
    var cards: [Card] { cardsContainer[selectedRange.rawValue] }
    var options: [[Option]] = []
    
    func setupBooksList(_ booksList: [[Book]]) {
        self.booksList = booksList
        arrangeContainer()
    }
    
    func arrangeContainer() {

        cardsContainer[LearnRange.all.rawValue] = selectedSection.cards
        cardsContainer[LearnRange.notLearned.rawValue] = selectedSection.cards.filter { $0.status(selectedBook.bookType) == .notLearned}
        cardsContainer[LearnRange.learning.rawValue] = selectedSection.cards.filter { $0.status(selectedBook.bookType) == .learning }
        
        for (index, _) in cardsContainer.enumerated() {
            cardsContainer[index].sort { $0.word < $1.word }
        }
        
        adjustSelectedRange()
    }
    
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

