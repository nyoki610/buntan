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
                    
                    Header("\(bookSharedData.selectedGrade.title)  \(bookSharedData.selectedBook.title)",
                           $bookSharedData.path)
                    
                    Spacer()
                    
                    progressView
                    
                    Spacer()
                    
                    selectView
                    
                    Spacer()
                    Spacer()
                    
                    TLButton(title: "学習を開始 →",
                             textColor: .white,
                             background: Orange.defaultOrange) {

                        guard let options = bookSharedData.selectedGrade.setupOptions(booksList: bookSharedData.booksList,
                                                                                      cards: bookSharedData.cards,
                                                                                      isBookView: true) else { return }
                        
                        bookSharedData.options = options
                        learnManager.setupLearn(bookSharedData.cards, bookSharedData.options)
                        bookSharedData.path.append(bookSharedData.selectedMode.viewName(isBookView: true))
                    }

                    Spacer()
                    Spacer()
                }
            }
            .background(CustomColor.background)
            .navigationBarBackButtonHidden(true)
    }
}
