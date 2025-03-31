import SwiftUI

extension LearnSelectView {
    
    @ViewBuilder
    var progressView: some View {
        
        progressViewTop

        progressViewMiddle
            .padding(.top, 4)
        
        Spacer()

        progressViewBottom
    }
    
    @ViewBuilder
    private var progressViewTop: some View {
        
        HStack {
            Text(bookSharedData.selectedSectionId)
                .bold()
            
            Spacer()
            
            Text("\(bookSharedData.allCount) words")
                .fontWeight(.medium)
        }
        .font(.system(size: responsiveSize(16, 20)))
        .padding(.horizontal, responsiveSize(60, 180))
    }
    
    @ViewBuilder
    private func customRectangle(color: Color, width: CGFloat) -> some View {
        
        Rectangle()
            .fill(color)
            .frame(width: width, height: 10)
            .cornerRadius(5)
    }
    
    @ViewBuilder
    private var progressViewMiddle: some View {
        
        ZStack(alignment: .leading) {
            
            customRectangle(color: .white, width: deviceType == .iPhone ? 300 : 400)
                .shadow(color: .gray.opacity(0.5), radius: 5, x: 5, y: 5)
            customRectangle(color: RoyalBlue.semiOpaque, width: bookSharedData.pinkWidth(deviceType))
            customRectangle(color: Orange.defaultOrange, width: bookSharedData.blueWidth(deviceType))
        }
        .padding(.horizontal, 20)
        
        HStack {
            Text("\(bookSharedData.progressPercentage) %")
                .font(.system(size: responsiveSize(16, 24)))
                .fontWeight(.bold)
                .foregroundColor(Orange.defaultOrange)
            
            Spacer()
        }
        .frame(width: deviceType == .iPhone ? 300 : 400)
        .offset(x: bookSharedData.blueWidth(deviceType) - 20)
    }
    
    @ViewBuilder
    private var progressViewBottom: some View {
        
        HStack {
            
            progressBottomButton {
                HStack {
                    Spacer()
                    Img.img(.arrowClockwise, color: .black)
                    Text("リセット")
                    Spacer()
                }
            } _: { resetAction() }
            
            Spacer()

            progressBottomButton {
                HStack {
                    Spacer()
                    Text("単語一覧")
                    Img.img(.arrowRight, color: .black)
                    Spacer()
                }
            } _: { bookSharedData.path.append(.wordList) }

        }
        .fontSize(responsiveSize(14, 18))
        .frame(width: responsiveSize(300, 400))
        .foregroundColor(.black)
    }
    
    @ViewBuilder
    private func progressBottomButton<Content: View>(
        @ViewBuilder content: () -> Content,
        _ action: @escaping () -> Void
    ) -> some View {
        
        Button {
            action()
        } label: {
            VStack {
                Spacer()
                content()
                Spacer()
            }
            .background(.white)
            .frame(width: responsiveSize(120, 180), height: responsiveSize(24, 30))
            .cornerRadius(5)
            .shadow(color: .gray.opacity(0.8), radius: 2, x: 0, y: 2)
        }
    }
}

extension LearnSelectView {
    
    func resetAction() {
        
        /// 「未学習の単語数」!=「全単語数」の場合のみ rest を行う
        guard bookSharedData.cardsContainer[LearnRange.notLearned.rawValue].count != bookSharedData.cardsContainer[LearnRange.all.rawValue].count else { return }
        
        alertSharedData.showSelectiveAlert(title: "現在の進捗を\nリセットしますか？",
                                           message: "",
                                           seconddaryButtonLabel: "リセット",
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
