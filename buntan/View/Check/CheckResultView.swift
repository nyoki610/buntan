import SwiftUI

struct CheckResultView: View {


    @EnvironmentObject var loadingSharedData: LoadingSharedData
    
    @ObservedObject private var navigator: CheckNavigator
    @ObservedObject private var userInput: CheckUserInput
    
    private let cards: [Card]
    private let correctIndexList: [Int]
    private let estimatedScore: Int
    
    private var correctPercentage: Int {
        Int((Double(correctIndexList.count) / Double(cards.count)) * 100)
    }
    
    init(
        navigator: CheckNavigator,
        userInput: CheckUserInput,
        cards: [Card],
        correctIndexList: [Int],
        estimatedScore: Int
    ) {
        self.navigator = navigator
        self.userInput = userInput
        /// not shuffled in checkLearnView
        self.cards = cards
        self.correctIndexList = correctIndexList
        self.estimatedScore = estimatedScore
    }
    
    
    var body: some View {
        
        WordList(
            cards: cards.map { $0 },
            showInfo: false,
            correctIndexList: correctIndexList
        ) {
            
            VStack {
                
                XmarkHeader() {
                    navigator.popToRoot()
                }
                
                Text(userInput.selectedGrade.title)
                    .fontSize(responsiveSize(20, 24))
                    .fontWeight(.bold)
                
                HStack {
                    Spacer()
                    circularProgressView(
                        title: "推定カバー率",
                        value: correctPercentage,
                        maxValue: 100,
                        color: Orange.translucent
                    )
                    Spacer()
                    
                    circularProgressView(
                        title: "予想得点",
                        value: estimatedScore,
                        maxValue: userInput.selectedGrade.questionCount,
                        color: Orange.egg
                    )

                    Spacer()
                }
                    .padding(.top, 20)
                
                Text("\(correctIndexList.count) 問正解！")
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
    private func circularProgressView(title: String, value: Int, maxValue: Int, color: Color) -> some View {
        
        VStack {
            
            Text(title)
                .fontSize(responsiveSize(16, 24))
            
            CircularProgress(
                staticValue: value,
                size: responsiveSize(120, 160),
                maxValue: maxValue,
                color: color
            )
        }
    }
}
