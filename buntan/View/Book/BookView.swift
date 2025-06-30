import SwiftUI

struct BookView: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType
    
    @ObservedObject private var pathHandler: BookViewPathHandler
    @StateObject private var userInput: BookUserInput = BookUserInput()
    
    init(pathHandler: BookViewPathHandler) {
        self.pathHandler = pathHandler
    }
    
    ///
    @State var allCardsCount: Int? = TestCruds.getAllCardsCount()
    @State var allInfomationsCount: Int? = TestCruds.getAllInfomationsCount()
    ///
    
    var body: some View {
        
        NavigationStack(path: $pathHandler.path) {
        
            ZStack {
            
                VStack(spacing: 0) {
                    
                    if let todaysWordCount = userInput.todaysWordCount {
                        headerView(todaysWordCount: todaysWordCount)
                            .padding(.top, 40)
                    }
                    
                    Spacer()
                    Spacer()
                    
                    eachGradeView(grade: .first)

                    Spacer()
                    
                    eachGradeView(grade: .preFirst)

                    Spacer()
                    
                    ///
                    VStack {
                        if let allCardsCount = allCardsCount {
                            Text("allCardsCount: \(allCardsCount)")
                        }
                        if let allInfomationsCount = allInfomationsCount {
                            Text("allInfomationsCount: \(allInfomationsCount)")
                        }
                    }
                    ///
                    
                    Spacer()
                    Spacer()
                }
            }
            .background(CustomColor.background)
            .navigationDestination(for: BookViewName.self) { viewName in
                viewName.viewForName(pathHandler: pathHandler, userInput: userInput)
            }
            .onAppear {
                if let todaysWordCount = LearnRecordRealmAPI.getTodaysWordCount() {
                    userInput.todaysWordCount = todaysWordCount
                }
            }
        }
    }
    
    
    /// headerView で使用する property
    /// ------------------------------
    private var variableValue: Double {
        guard let todaysWordCount = userInput.todaysWordCount else { return 0.0 }
        if todaysWordCount >= 1000 { return 1.0 }
        if todaysWordCount >= 100 { return 0.5 }
        if todaysWordCount >= 10 { return 0.3 }
        return 0.0
    }
    /// ------------------------------
    
    @ViewBuilder
    private func headerView(todaysWordCount: Int) -> some View {
        
        HStack {
            VStack {
                Text("今日の")
                Text("学習単語")
            }
            .font(.system(size: responsiveSize(14, 20)))
            
            Image(systemName: "chart.bar.fill",
                  variableValue: variableValue)
            .font(.system(size: responsiveSize(30, 40)))
            .foregroundStyle(Orange.defaultOrange)
            
            Text("\(todaysWordCount) words")
                .padding(.top, 10)
                .font(.system(size: responsiveSize(17, 24)))

            Spacer()
        }
        .fontWeight(.bold)
        .padding(.vertical, 10)
        .padding(.horizontal, 40)
    }
    
    @ViewBuilder
    private func eachGradeView(grade: EikenGrade) -> some View {
        
        VStack(spacing: 0) {
            Text(grade.title)
                .foregroundColor(.white)
                .fontWeight(.heavy)
                .font(.system(size: responsiveSize(20, 28)))
                .padding(.top, 20)
                
            HStack {
                Spacer()
                selectBookCategoryButton(grade: grade, bookCategory: .freq)
                Spacer()
                selectBookCategoryButton(grade: grade, bookCategory: .pos)
                Spacer()
            }
            .padding(.vertical, 20)
        }
        .foregroundColor(.black)
        .background(grade.color)
        .cornerRadius(10)
        .padding(.horizontal, responsiveSize(10, 60))
    }
    
    @ViewBuilder
    private func selectBookCategoryButton(grade: EikenGrade, bookCategory: BookCategory) -> some View {
                
        Button {
            userInput.selectedGrade = grade
            userInput.selectedBookCategory = bookCategory
            
            guard let bookList: [Book] = SheetRealmAPI
                .getBookListByGradeAndCategory(
                    eikenGrade: grade,
                    bookCategory: bookCategory
                ) else { return }
            
            pathHandler.transitionScreen(to: .bookList(bookList))
        } label: {
            HStack {
                Text(bookCategory.buttonLabel)
                    .padding(.trailing, 10)
                Image(systemName: "chevron.right.2")
            }
            .fontWeight(.heavy)
            .font(.system(size: responsiveSize(18, 24)))
            .frame(width: responsiveSize(160, 240), height: responsiveSize(50, 70))
            .background(.white)
            .cornerRadius(10)
        }
    }
}
