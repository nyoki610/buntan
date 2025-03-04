import Foundation

extension BookSharedData {

    var notLearnedCount: Int {
        cardsContainer[LearnRange.notLearned.rawValue].count
    }
    var learnCount: Int {
        cardsContainer[LearnRange.learning.rawValue].count
    }
    var allCount:Int {
        cardsContainer[LearnRange.all.rawValue].count
    }
    
    var progressPercentage: Int {
        Int((1.0 - ((Double(notLearnedCount) + Double(learnCount)) / Double(allCount))) * 100)
    }
    func pinkWidth(_ deviceType: DeviceType) -> CGFloat {
        let fullLength: CGFloat = deviceType == .iPhone ? 300 : 400
        return fullLength * (CGFloat(learnCount) / CGFloat(allCount)) + blueWidth(deviceType)
    }
    func blueWidth(_ deviceType: DeviceType) -> CGFloat {
        let fullLength: CGFloat = deviceType == .iPhone ? 300 : 400
        return fullLength * (CGFloat(1) - (CGFloat(notLearnedCount) + CGFloat(learnCount)) / CGFloat(allCount))
    }
}
