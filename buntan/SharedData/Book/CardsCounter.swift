import Foundation


/// card に関する値を計算する extension
extension BookSharedData {

    var notLearnedCount: Int {
        cardsContainer[LearnRange.notLearned.rawValue].count
    }
    var learningCount: Int {
        cardsContainer[LearnRange.learning.rawValue].count
    }
    var allCount:Int {
        cardsContainer[LearnRange.all.rawValue].count
    }
    var learnedCount: Int {
        allCount - notLearnedCount - learningCount
    }
    
    var progressPercentage: Int {
        Int((1.0 - ((Double(notLearnedCount) + Double(learningCount)) / Double(allCount))) * 100)
    }
}
