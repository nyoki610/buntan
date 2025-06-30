import SwiftUI

struct LearnResultView: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType: DeviceType
    
    @EnvironmentObject var loadingSharedData: LoadingSharedData
    @EnvironmentObject var learnManager: LearnManager

    /// 「学習中」の単語が存在するかどうかを示す bool 値
    private var reviewAll: Bool { cardsContainer.learningCount == 0 }
    
    @ObservedObject private var pathHandler: BookViewPathHandler
    @ObservedObject private var userInput: BookUserInput
    private let cardsContainer: CardsContainer

    init(pathHandler: BookViewPathHandler, userInput: BookUserInput, cardsContainer: CardsContainer) {
        self.pathHandler = pathHandler
        self.userInput = userInput
        self.cardsContainer = cardsContainer
    }
    
    var body: some View {
        
        VStack {
            
            XmarkHeader() {
                pathHandler.backToPreviousScreen(count: 3)
                pathHandler.transitionScreen(to: .learnSelect(cardsContainer))
            }
            
            Spacer()
            
            resultView
            
            Spacer()
            Spacer()
            
            StartButton(label: reviewAll ? "すべての単語を復習　→" : "学習中の単語を復習　→",
                        color: reviewAll ? Orange.defaultOrange : RoyalBlue.defaultRoyal) {
                buttonAction(isNotLearnedButtonAction: false)
            }
                         
            
            if cardsContainer.notLearnedCount != 0 {
                StartButton(label: "未学習の単語を学習　→",
                            color: .gray) {
                    buttonAction(isNotLearnedButtonAction: true)
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
            
            CircularProgress(staticValue: cardsContainer.progressPercentage,
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
                
                Text("\(cardsContainer.learnedCount)")
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
                
                Text("\(cardsContainer.learningCount)")
                    .fontSize(responsiveSize(20, 24))
                    .fontWeight(.bold)
                
                Text("words")
            }
            .fontSize(responsiveSize(16, 24))
            .padding(.top, 20)
            .frame(width: responsiveSize(160, 200))
            .foregroundColor(RoyalBlue.defaultRoyal)
            
            
            /// 未学習の単語が存在する場合のみ「未学習の単語を学習」ボタンを表示
            if cardsContainer.notLearnedCount != 0 {
                
                HStack {
                    VStack {
                        Text("未学習")
                            .fontWeight(.medium)
                    }
                    .frame(width: responsiveSize(60, 80))
                    
                    Spacer()
                    
                    Text("\(cardsContainer.notLearnedCount)")
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

    
    private func buttonAction(isNotLearnedButtonAction: Bool) -> Void {
        
        /// 次に学習する範囲を設定
        userInput.selectedRange = isNotLearnedButtonAction ? .notLearned : reviewAll ? .all : .learning
        
        guard let selectedGrade = userInput.selectedGrade else { return }
        
        let cards = cardsContainer.getCardsByLearnRange(
            learnRange: userInput.selectedRange
        )
        /// options を初期化
        guard let options = SheetRealmAPI.getOptions(
            eikenGrade: selectedGrade,
            cards: cards,
            containFifthOption: false
        ) else { return }
        
        /// ここで再学習時に新規のoptionを引き継ぐ処理が必要
//        bookSharedData.options = options
        
        /// 学習モードを初期化
        learnManager.setupLearn(cards, options)
        
        /// 画面遷移
        pathHandler.backToPreviousScreen(count: 1)
    }
}
