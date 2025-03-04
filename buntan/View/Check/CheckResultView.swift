import SwiftUI

struct CheckResultView: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType: DeviceType
    // Recordクラス内から直接保存できるように修正したい
    @EnvironmentObject var realmService: RealmService
    @EnvironmentObject var loadingSharedData: LoadingSharedData
    
    @EnvironmentObject var checkSharedData: CheckSharedData
    @EnvironmentObject var learnManager: LearnManager
    
    var correctPercentage: Int {
        Int((Double(learnManager.rightCardsIndexList.count) / Double(learnManager.cards.count)) * 100)
    }
    
    var body: some View {
        
        WordList(cards: learnManager.cards.map { $0 },
                 showInfo: false,
                 correctIndexList: learnManager.rightCardsIndexList) {
            
            VStack {
                
                XmarkHeader() {
                    checkSharedData.path = []
                }
                
                Text(checkSharedData.selectedGrade.title)
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
                             checkSharedData.estimatedScore(learnManager),
                             checkSharedData.selectedGrade.questionCount,
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
}
