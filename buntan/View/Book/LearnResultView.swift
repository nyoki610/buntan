import SwiftUI

struct LearnResultView: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType: DeviceType
    // Recordクラス内から直接保存できるように修正したい
    @EnvironmentObject var realmService: RealmService
    @EnvironmentObject var loadingSharedData: LoadingSharedData
    
    @EnvironmentObject var bookSharedData: BookSharedData
    @EnvironmentObject var learnManager: LearnManager
    
    @State private var progressValue: Int = 0
    @State private var staticProgressValue: Int = 0
    
    private var notLearnedCount: Int { bookSharedData.cardsContainer[LearnRange.notLearned.rawValue].count }
    private var learningCount: Int { bookSharedData.cardsContainer[LearnRange.learning.rawValue].count }
    private var completedCount: Int { bookSharedData.cardsContainer[LearnRange.all.rawValue].count - notLearnedCount - learningCount }
    
    private var reviewAll: Bool { learningCount == 0 }
    
    var body: some View {
        
        VStack {
            
            XmarkHeader() {
                bookSharedData.path.removeLast(2)
            }
            
            Spacer()
            
            resultView
            
            Spacer()
            Spacer()
            
            TLButton(title: reviewAll ? "すべての単語を復習　→" : "学習中の単語を復習　→",
                     textColor: .white,
                     background: reviewAll ? Orange.defaultOrange : RoyalBlue.defaultRoyal) {
                buttonAction(isNotLearned: false)
            }
            
            if notLearnedCount != 0 {
                
                TLButton(title: "未学習の単語を学習　→",
                         textColor: .white,
                         background: .gray) {
                    buttonAction(isNotLearned: true)
                }
                         .padding(.top, responsiveSize(20, 40))
            }
            
            Spacer()
            Spacer()
        }
        .background(.clear)
        .navigationBarBackButtonHidden(true)
    }
    
    @ViewBuilder
    private var resultView: some View {
        
        VStack {
            
            Text("\(learnManager.cards.count) words の学習を終えました！")
                .fontSize(responsiveSize(20, 28))
                .bold()
            
            CircularProgress(staticValue: bookSharedData.progressPercentage,
                             size: responsiveSize(150, 200),
                             maxValue: 100,
                             color: Orange.defaultOrange)

                .padding(.top, 20)
            
            HStack {
                VStack {
                    Text("完了")
                        .fontWeight(.medium)
                }
                .frame(width: 60)
                
                Spacer()
                
                Text("\(completedCount)")
                    .fontSize(responsiveSize(20, 24))
                    .fontWeight(.bold)
                
                Text("words")
            }
            .fontSize(responsiveSize(16, 24))
            .padding(.top, 40)
            .frame(width: responsiveSize(160, 200))
            .foregroundColor(Orange.defaultOrange)
            
            HStack {
                VStack {
                    Text("学習中")
                        .fontWeight(.medium)
                }
                .frame(width: responsiveSize(60, 80))
                
                Spacer()
                
                Text("\(learningCount)")
                    .fontSize(responsiveSize(20, 24))
                    .fontWeight(.bold)
                
                Text("words")
            }
            .fontSize(responsiveSize(16, 24))
            .padding(.top, 20)
            .frame(width: responsiveSize(160, 200))
            .foregroundColor(RoyalBlue.defaultRoyal)
            
            if notLearnedCount != 0 {
                
                HStack {
                    VStack {
                        Text("未学習")
                            .fontWeight(.medium)
                    }
                    .frame(width: responsiveSize(60, 80))
                    
                    Spacer()
                    
                    Text("\(notLearnedCount)")
                        .fontSize(responsiveSize(20, 24))
                        .fontWeight(.bold)
                    
                    Text("words")
                }
                .fontSize(responsiveSize(16, 24))
                .padding(.top,20)
                .frame(width: responsiveSize(160, 200))
                .foregroundColor(.gray)
            }
        }
    }
    
    private func buttonAction(isNotLearned: Bool) -> Void {
        
        bookSharedData.selectedRange = isNotLearned ? .notLearned : reviewAll ? .all : .learning
        guard let options = bookSharedData.selectedGrade.setupOptions(booksList: bookSharedData.booksList,
                                                                      cards: bookSharedData.cards,
                                                                      isBookView: true) else { return }
        bookSharedData.options = options
        learnManager.setupLearn(bookSharedData.cards, bookSharedData.options)
        bookSharedData.path.removeLast()
    }
}
