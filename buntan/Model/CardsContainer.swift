//
//  CardsContainer.swift
//  buntan
//
//  Created by 二木裕也 on 2025/06/21.
//

import Foundation


struct CardsContainer: Hashable {

    let allCards: [Card]
    let notLearnedCards: [Card]
    let learningCards: [Card]
    
    init(cards: [Card], bookCategory: BookCategory) {
        
        self.allCards = cards
            .sorted { $0.word < $1.word }
        
        self.notLearnedCards = allCards
            .filter { $0.status(bookCategory) == .notLearned}
        
        self.learningCards = allCards
            .filter { $0.status(bookCategory) == .learning }
    }
    
    /// userInputから対応するCardContainerをinit
    init?(userInput: BookUserInput) {
        guard let selectedGrade = userInput.selectedGrade,
              let selectedBookCategory = userInput.selectedBookCategory,
              let selectedBookConfig = userInput.selectedBookConfig,
              let selectedSectionTitle = userInput.selectedSectionTitle else { return nil }
        
        guard let cards: [Card] = SheetRealmAPI.getSectionCards(
            eikenGrade: selectedGrade,
            bookCategory: selectedBookCategory,
            bookConfig: selectedBookConfig,
            sectionTitle: selectedSectionTitle
        ) else { return nil }
        
        self.allCards = cards
            .sorted { $0.word < $1.word }
        
        self.notLearnedCards = allCards
            .filter { $0.status(selectedBookCategory) == .notLearned}
        
        self.learningCards = allCards
            .filter { $0.status(selectedBookCategory) == .learning }
    }
    
    func getCardsByLearnRange(learnRange: LearnRange) -> [Card] {
        switch learnRange {
        case .all: return allCards
        case .notLearned: return notLearnedCards
        case .learning: return learningCards
        }
    }
}


extension CardsContainer {
    
    var notLearnedCount: Int {
        notLearnedCards.count
    }
    var learningCount: Int {
        learningCards.count
    }
    var allCount:Int {
        allCards.count
    }
    var learnedCount: Int {
        allCount - notLearnedCount - learningCount
    }
    
    var progressPercentage: Int {
        Int((1.0 - ((Double(notLearnedCount) + Double(learningCount)) / Double(allCount))) * 100)
    }
}
