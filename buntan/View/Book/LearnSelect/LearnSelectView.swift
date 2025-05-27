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
                    
                    let title = bookSharedData.selectedGrade.title + "   " + bookSharedData.selectedBook.title + "   " +  bookSharedData.selectedSectionId

                    Header(path: $bookSharedData.path, title: title)
                    
                    subButtonView
                    
                    Spacer()
                    
                    progressView
                    
                    Spacer()
                    
                    selectView
                        .frame(width: responsiveSize(280, 360))
                    
                    Spacer()
                    
                    StartButton(label: "学習を開始 →",
                                color: Orange.defaultOrange) {
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
        
        HStack {
            
            LearnSelectCircle(
                firstCircle: .init(value: bookSharedData.allCount - bookSharedData.notLearnedCount, color: RoyalBlue.semiOpaque),
                secondCircle: .init(value: bookSharedData.learnedCount, color: Orange.defaultOrange),
                size: responsiveSize(140, 200),
                maxValue: bookSharedData.allCount
            )
            
            Spacer()
            
            VStack(alignment: .leading) {
                Spacer()
                Spacer()
                Spacer()
                circleAnnotation(label: "完了", color: Orange.defaultOrange)
                circleAnnotation(label: "学習中", color: RoyalBlue.semiOpaque)
                Spacer()
            }
            .frame(height: 140)
        }
        .frame(width: responsiveSize(300, 400))
    }
    
    @ViewBuilder
    private func circleAnnotation(label: String, color: Color) -> some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: responsiveSize(16, 20), height: responsiveSize(16, 20))
            Text(label)
                .fontWeight(.medium)
                .font(.system(size: responsiveSize(16, 20)))
        }
    }
    
    @ViewBuilder
    private var subButtonView: some View {
        
        HStack {
            /// 「未学習の単語数」!=「全単語数」の場合のみ表示
            if bookSharedData.cardsContainer[LearnRange.notLearned.rawValue].count != bookSharedData.cardsContainer[LearnRange.all.rawValue].count {
                subButton(label: "リセット",
                          systemName: "arrow.clockwise",
                          color: .red) {
                    resetAction()
                }
            }
            Spacer()
            subButton(label: "単語一覧",
                      systemName: "info.circle.fill",
                      color: .blue) {
                bookSharedData.path.append(.wordList)
            }
        }
        .frame(width: responsiveSize(300, 420))
        .font(.system(size: responsiveSize(14, 20)))
        .fontWeight(.bold)
    }

    
    @ViewBuilder
    private func subButton(label: String, systemName: String, color: Color, action: @escaping () -> Void) -> some View {
        
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: systemName)
                    .font(.system(size: responsiveSize(18, 22)))
                Text(label)
                    .fontWeight(.medium)
            }
            .foregroundStyle(color)
            .padding(.horizontal, 16)
            .padding(.vertical, 2)
            .background(.white)
            .cornerRadius(responsiveSize(12, 15))
            .shadow(color: .gray.opacity(0.8), radius: 2, x: 0, y: 2)
        }
    }
}

extension LearnSelectView {
    
    func resetAction() {
        
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
