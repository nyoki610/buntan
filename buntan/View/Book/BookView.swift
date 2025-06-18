import SwiftUI

struct BookView: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType
    
    @EnvironmentObject var realmService: RealmService
    @EnvironmentObject var bookSharedData: BookSharedData
    
    var body: some View {
        
        NavigationStack(path: $bookSharedData.path) {
        
            ZStack {
            
                VStack(spacing: 0) {
                    
                    headerView
                        .padding(.top, 40)
                    
                    Spacer()
                    Spacer()
                    
                    eachGradeView(grade: .first)

                    Spacer()
                    
                    eachGradeView(grade: .preFirst)

                    Spacer()
                    Spacer()
                    Spacer()
                }
            }
            .background(CustomColor.background)
            .navigationDestination(for: ViewName.self) { viewName in
                viewName.viewForName(viewName)
            }
        }
        .trackScreenView(viewName: .book)
    }
    
    
    /// headerView で使用する property
    /// ------------------------------
    private var todayLearnCount: Int {
        
        guard let lastRecord = realmService.combinedRecords.last else { return 0 }
       
        let lastRecordDate = Calendar.current.dateComponents([.year, .month, .day], from: lastRecord.date)
        let today = Calendar.current.dateComponents([.year, .month, .day], from: Date())

        return lastRecordDate == today ? lastRecord.learnedCardCount : 0
   }
    private var variableValue: Double {
        if todayLearnCount >= 1000 { return 1.0 }
        if todayLearnCount >= 100 { return 0.5 }
        if todayLearnCount >= 10 { return 0.3 }
        return 0.0
    }
    /// ------------------------------
    
    @ViewBuilder
    private var headerView: some View {
        
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
                
            Text("\(todayLearnCount) words")
                .padding(.top, 10)
                .font(.system(size: responsiveSize(17, 24)))

            Spacer()
        }
        .fontWeight(.bold)
        .padding(.vertical, 10)
        .padding(.horizontal, 40)
    }
    
    @ViewBuilder
    private func eachGradeView(grade: Eiken) -> some View {
        
        VStack(spacing: 0) {
            Text(grade.title)
                .foregroundColor(.white)
                .fontWeight(.heavy)
                .font(.system(size: responsiveSize(20, 28)))
                .padding(.top, 20)
                
            HStack {
                Spacer()
                selectBookTypeButton(grade: grade, bookType: .freq)
                Spacer()
                selectBookTypeButton(grade: grade, bookType: .pos)
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
    private func selectBookTypeButton(grade: Eiken, bookType: BookType) -> some View {
                
        Button {
            guard let sheet = realmService.sheets.first(where: { $0.grade == grade }) else { return }
            bookSharedData.selectedGrade = sheet.grade
            bookSharedData.selectedBookType = bookType
            bookSharedData.path.append(.bookList)
        } label: {
            HStack {
                Text(bookType.buttonLabel)
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
