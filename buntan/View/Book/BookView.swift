import SwiftUI

struct BookView: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType
    @EnvironmentObject var realmService: RealmService
    @EnvironmentObject var bookSharedData: BookSharedData
    
    var todayLearnCount: Int {
        
        guard let lastRecord = realmService.combinedRecords.last else { return 0 }
       
        let lastRecordDate = Calendar.current.dateComponents([.year, .month, .day], from: lastRecord.date)
        let today = Calendar.current.dateComponents([.year, .month, .day], from: Date())

        return lastRecordDate == today ? lastRecord.learnedCardCount : 0
   }
    
    var variableValue: Double {
        if todayLearnCount >= 1000 { return 1.0 }
        if todayLearnCount >= 100 { return 0.5 }
        if todayLearnCount >= 10 { return 0.3 }
        return 0.0
    }
    
    var body: some View {
        
        NavigationStack(path: $bookSharedData.path) {
        
            ZStack {
            
                VStack {
                    
                    headerView
                        .padding(.top, 40)
                    
                    Spacer()
                    
                    selectButtonView

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
    private func sectionHeader(_ sectionTitle: String) -> some View {
        
        HStack {
            Text(sectionTitle)
                .fontWeight(.bold)
                .font(.system(size: 20))
                .opacity(0.7)
            Spacer()
        }
        .padding(.leading, 40)
        .padding(.top, 40)
        .padding(.bottom, 20)
    }
    
    @ViewBuilder
    private var selectButtonView: some View {
        
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
                    /// 要素数が奇数の場合
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
