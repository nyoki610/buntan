import SwiftUI

struct CheckResultView: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType: DeviceType

    @EnvironmentObject var loadingSharedData: LoadingSharedData

    @EnvironmentObject var learnManager: LearnManager
    
    var correctPercentage: Int {
        Int((Double(learnManager.rightCardsIndexList.count) / Double(learnManager.cards.count)) * 100)
    }
    
    @ObservedObject private var pathHandler: CheckViewPathHandler
    @ObservedObject private var userInput: CheckUserInput
    
    init(pathHandler: CheckViewPathHandler, userInput: CheckUserInput) {
        self.pathHandler = pathHandler
        self.userInput = userInput
    }
    
    
    var body: some View {
        
        WordList(cards: learnManager.cards.map { $0 },
                 showInfo: false,
                 correctIndexList: learnManager.rightCardsIndexList) {
            
            VStack {
                
                XmarkHeader() {
                    pathHandler.backToRootScreen()
                }
                
                Text(userInput.selectedGrade.title)
                    .fontSize(responsiveSize(20, 24))
                    .fontWeight(.bold)
                
                HStack {
                    Spacer()
                    progress("推定カバー率",
                             correctPercentage,
                             100,
                             Orange.translucent)
                    Spacer()
                    progress("予想得点",
                             estimatedScore(learnManager: learnManager),
                             userInput.selectedGrade.questionCount,
                             Orange.egg)
                    Spacer()
                }
                    .padding(.top, 20)
                
                Text("\(learnManager.rightCardsIndexList.count) 問正解！")
                    .fontSize(responsiveSize(16, 20))
                    .fontWeight(.bold)
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                
            }
        }
        .background(.clear)
        .navigationBarBackButtonHidden(true)
    }
    
    @ViewBuilder
    private func progress(_ title: String, _ value: Int, _ maxValue: Int, _ color: Color) -> some View {
        
        VStack {
            
            Text(title)
                .fontSize(responsiveSize(16, 24))
            
            CircularProgress(staticValue: value,
                             size: responsiveSize(120, 160),
                             maxValue: maxValue,
                             color: color)
        }
    }
    
    func estimatedScore(learnManager: LearnManager) -> Int {
        
        var fullScore: Double = 0
        var score: Double = 0
        
        for (index, card) in learnManager.cards.enumerated() {
            
            let cardScore = card.infoList.reduce(0.0) { $0 + ($1.isAnswer ? 3 : 1) }
            
            fullScore += cardScore
            
            if learnManager.rightCardsIndexList.contains(index) {
                score += cardScore
            }
        }
        return Int((score / fullScore) * EikenGrade.first.questionCount.double)
    }
}
