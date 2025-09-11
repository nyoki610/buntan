import SwiftUI


extension MainView {
    
    var tabView: some View {
        
        VStack {
         
            Spacer()
            
            HStack {
                Spacer()

                tabButton("book.fill", "単語帳", for: .book)

                tabButton("checklist.checked", "テスト", for: .check)
                    .padding(.horizontal, responsiveSize(20, 60))
                tabButton("shoeprints.fill", "記録", for: .record)
                    .padding(.bottom, responsiveSize(0, 20))
                
                Spacer()
                
            }
        }
    }
    
    @ViewBuilder
    private func tabButton(_ systemName: String, _ title: String, for viewName: MainViewName.Root) -> some View {
        
        let targetViewName = MainViewName.root(viewName)
        let isSelected = (viewModel.selectedViewName == targetViewName)
        
        Button {
            viewModel.selectedViewName = targetViewName
            AnalyticsLogger.logScreenTransition(viewName: targetViewName)
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
