import SwiftUI

struct LearnSelectView: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType: DeviceType
    
    @EnvironmentObject var realmService: RealmService
    @EnvironmentObject var bookSharedData: BookSharedData
    @EnvironmentObject var alertSharedData: AlertSharedData
    @EnvironmentObject var loadingSharedData: LoadingSharedData
    @EnvironmentObject var learnManager: LearnManager

    var body: some View {
            
            ZStack {
                
                VStack {
                    
                    let title = bookSharedData.selectedGrade.title + " " + bookSharedData.selectedBook.title + " " +  bookSharedData.selectedSectionId

                    Header(path: $bookSharedData.path, title: title)
                    
                    HStack {
                        resetButton
                        Spacer()
                        wordListButton
                    }
                    .padding(.horizontal, 40)
                    .font(.system(size: responsiveSize(14, 20)))
                    .fontWeight(.bold)
                    
                    progressView
                    
                    Spacer()
                    
                    selectView
                    
                    Spacer()
                    
                    StartButton(title: "学習を開始 →") {
                        guard let options = bookSharedData.selectedGrade.setupOptions(
                            booksList: bookSharedData.booksList,
                            cards: bookSharedData.cards,
                            isBookView: true
                        ) else { return }
                        
                        bookSharedData.options = options
                        learnManager.setupLearn(bookSharedData.cards, bookSharedData.options)
                        bookSharedData.path.append(bookSharedData.selectedMode.viewName(isBookView: true))
                    }

                    Spacer()
                }
            }
            .background(CustomColor.background)
            .navigationBarBackButtonHidden(true)
    }
    
    @ViewBuilder
    var progressView: some View {
        
        LearnSelectCircle(
            firstCircle: .init(value: bookSharedData.allCount - bookSharedData.notLearnedCount, color: RoyalBlue.semiOpaque),
            secondCircle: .init(value: bookSharedData.learnedCount, color: Orange.defaultOrange),
            size: 140,
            maxValue: bookSharedData.allCount
        )
    }
    
    @ViewBuilder
    private var resetButton: some View {
        
        Button {
            resetAction()
        } label: {
            Img.img(.arrowClockwise,
                    color: .red)
            Text("進捗をリセット")
        }
        .foregroundStyle(.red)
    }
    
    @ViewBuilder
    private var wordListButton: some View {
        
        Button {
            bookSharedData.path.append(.wordList)
        } label: {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image(systemName: "info.circle.fill")
                    Text("単語一覧")
                        .fontWeight(.medium)
                    Spacer()
                }
                Spacer()
            }
            .foregroundStyle(.blue)
            .background(.white)
            .frame(width: responsiveSize(120, 180), height: responsiveSize(24, 30))
            .cornerRadius(responsiveSize(12, 15))
            .shadow(color: .gray.opacity(0.8), radius: 1, x: 0, y: 1)
        }
    }
}

extension LearnSelectView {
    
    func resetAction() {
        
        /// 「未学習の単語数」!=「全単語数」の場合のみ rest を行う
        guard bookSharedData.cardsContainer[LearnRange.notLearned.rawValue].count != bookSharedData.cardsContainer[LearnRange.all.rawValue].count else { return }
        
        alertSharedData.showSelectiveAlert(title: "現在の進捗を\nリセットしますか？",
                                           message: "",
                                           secondaryButtonLabel: "リセット",
                                           secondaryButtonType: .destructive) {
            loadingSharedData.startLoading(.process)
            
            /// ensure loading screen rendering by delaying the next process
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                
                guard let updatedBooksList = realmService.resetProgress(bookSharedData.cardsContainer[LearnRange.all.rawValue],
                                                                        bookSharedData.selectedGrade,
                                                                        bookSharedData.selectedBook.bookType) else { return }
                bookSharedData.setupBooksList(updatedBooksList)

                loadingSharedData.finishLoading {}
            }
        }
    }
}
