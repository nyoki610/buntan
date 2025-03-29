import SwiftUI


extension MainView {
    
    
    /// BookView() or CheckView or RecordView() 表示時のみtabViewを表示
    ///     - BookView() -> bookSharedData.path が空かどうかを監視
    ///     - CheckView() -> checkSharedData.path が空かどうかを監視
    ///     - RecordView() -> 常に tabView を表示
    var showTabView: Bool { bookSharedData.path.isEmpty && checkSharedData.path.isEmpty }
    
    var tabView: some View {
        
        VStack {
         
            if showTabView {
                
                Spacer()
                
                HStack {
                    Spacer()

                    tabButton(.bookFill, "単語帳", .book)

                    tabButton(.checklistChecked, "テスト", .check)
                        .padding(.horizontal, responsiveSize(20, 60))
                    tabButton(.shoeprintsFill, "記録", .record)
                        .padding(.bottom, responsiveSize(0, 20))
                    
                    Spacer()
                    
                }
            }
        }
    }
    
    @ViewBuilder
    private func tabButton(_ image: Img, _ title: String, _ targetTab: TabType) -> some View {
        
        let isSelected = self.selectedTab == targetTab
        
        Button {
            self.selectedTab = targetTab
        } label: {
            
            VStack {
                
                ZStack {
                    
                    Circle()
                        .foregroundColor(isSelected ? .orange.opacity(0.3) : .gray.opacity(0.1))
                        .frame(height: responsiveSize(60, 90))
                    
                    Img.img(image,
                            size: responsiveSize(26, 39),
                            color: isSelected ? Orange.defaultOrange : .gray)
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
    
    /// 表示する View をコントロールする enum
    enum TabType {
        case book, check, record
        
        @ViewBuilder
        var view: some View {
            switch self {
            case .book: BookView()
            case .check: CheckView()
            case .record: RecordView()
            }
        }
    }
}
