import SwiftUI


extension MainView {
    
    
    /// BookView() or CheckView or RecordView() 表示時のみtabViewを表示
    ///     - BookView() -> bookSharedData.path が空かどうかを監視
    ///     - CheckView() -> checkSharedData.path が空かどうかを監視
    ///     - RecordView() -> 常に tabView を表示
    var showTabView: Bool { bookViewPathHandler.isEmpty && checkViewPathHandler.isEmpty }
    
    var tabView: some View {
        
        VStack {
         
            if showTabView {
                
                Spacer()
                
                HStack {
                    Spacer()

                    tabButton("book.fill", "単語帳", .book)

                    tabButton("checklist.checked", "テスト", .check)
                        .padding(.horizontal, responsiveSize(20, 60))
                    tabButton("shoeprints.fill", "記録", .record)
                        .padding(.bottom, responsiveSize(0, 20))
                    
                    Spacer()
                    
                }
            }
        }
    }
    
    @ViewBuilder
    private func tabButton(_ systemName: String, _ title: String, _ targetViewName: RootViewName) -> some View {
        
        let isSelected = self.selectedRootViewName == targetViewName
        
        Button {
            self.selectedRootViewName = targetViewName
            AnalyticsHandler.logScreenTransition(viewName: ViewName.root(targetViewName))
        } label: {
            
            VStack {
                
                ZStack {
                    
                    Circle()
                        .foregroundColor(isSelected ? .orange.opacity(0.3) : .gray.opacity(0.1))
                        .frame(height: responsiveSize(60, 90))
                    

                    Image(systemName: systemName)
                        .font(.system(size: responsiveSize(26, 39)))
                        .fontWeight(.bold)
                        .foregroundStyle(isSelected ? Orange.defaultOrange : .gray)
                        
                        
                }

                Text(title)
                    .foregroundColor(isSelected ? Orange.defaultOrange : .gray)
                    .font(.system(size: responsiveSize(14, 21)))
                    .fontWeight(.bold)
                    .padding(.top, 4)
            }
        }
        .frame(width: responsiveSize(80, 120))
        .contentShape(Rectangle())
    }
}
