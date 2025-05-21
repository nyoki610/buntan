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
                    
                    _selectButtonView(grade: .first)
                        .padding(.bottom, 40)
                    
                    _selectButtonView(grade: .preFirst)


                    Spacer()
                    Spacer()
                }
            }
            .background(CustomColor.background)
            .navigationDestination(for: ViewName.self) { viewName in
                viewName.viewForName(viewName)
            }
        }
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
            .fontWeight(.medium)
            
            Img.img(.chartBarFill,
                    variableValue: variableValue,
                    size: responsiveSize(30, 40),
                    color: Orange.defaultOrange)
            
            Text("\(todayLearnCount) words")
                .padding(.top, 10)
                .fontWeight(.medium)
            
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 40)
    }
    
    @ViewBuilder
    private func _selectButtonView(grade: Eiken) -> some View {
        
        VStack(spacing: 0) {
            Text(grade.title)
                .foregroundColor(.white)
                .fontWeight(.heavy)
                .font(.system(size: responsiveSize(20, 28)))
                .padding(.top, 20)
                
            HStack {
                Spacer()
                customButton(grade: grade, bookType: .freq)
                Spacer()
                customButton(grade: grade, bookType: .pos)
                Spacer()
            }
            .padding(.vertical, 20)
        }
        .foregroundColor(.black)
        .background(grade.color)
        .cornerRadius(10)
        .padding(.horizontal, 10)
    }
    
    @ViewBuilder
    private func customButton(grade: Eiken, bookType: BookType) -> some View {
                
        Button {
            guard let sheet = realmService.sheets.first(where: { $0.grade == grade }) else { return }
            bookSharedData.selectedGrade = sheet.grade
            bookSharedData.selectedBookType = bookType
            bookSharedData.path.append(.bookList)
        } label: {
            HStack {
                Text(bookType.buttonLabel)
                    .fontWeight(.heavy)
                    .padding(.trailing, 10)
                Image(systemName: "chevron.right.2")
            }
            .font(.system(size: responsiveSize(18, 24)))
            .frame(width: responsiveSize(160, 240), height: responsiveSize(50, 70))
            .background(.white)
            .cornerRadius(10)
        }
    }


    @ViewBuilder
    private var selectButtonView: some View {
        
        
        /// 「〇〇級」のボタンを横方向に ２個ずつ配置する
        ForEach(Array(stride(from: 0, to: Eiken.allCases.count, by: 2)), id: \.self) { index in

                if index + 1 < Eiken.allCases.count {
                    HStack {
                        Spacer()
                        selectButton(Eiken.allCases[index])
                        Spacer()
                        selectButton(Eiken.allCases[index + 1])
                        Spacer()
                    }
                    .padding(.bottom, responsiveSize(20, 40))
                } else {
                    /// 要素数が奇数の場合は最後の１個は中央寄せ
                    selectButton(Eiken.allCases[index])
                }
            }
    }
    
    @ViewBuilder
    private func selectButton(_ grade: Eiken) -> some View {
        
        let sheet = realmService.sheets.first(where: { $0.grade == grade })
        let buttonDisabled = (sheet == nil)
        
        Button {
            guard let sheet = sheet else { return }
            bookSharedData.selectedGrade = sheet.grade
            bookSharedData.path.append(.bookList)
        } label: {
            
            ZStack {

                VStack {
                    Text(grade.title)
                        .foregroundColor(.white)
                        .fontWeight(.heavy)
                }
                
                 if buttonDisabled {
                     
                     Text("準備中")
                         .foregroundColor(.gray)
                         .bold()
                 }
            }
            .font(.system(size: responsiveSize(18, 24)))
            .frame(width: responsiveSize(160, 240), height: responsiveSize(50, 70))
            .background(grade.color.opacity(buttonDisabled ? 0.2 : 0.8))
            .cornerRadius(10)
        }
        .disabled(buttonDisabled)
    }
}
