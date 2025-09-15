import SwiftUI

struct RecordView: View {
    

    
    @State var viewType: CheckViewType = .learn
    
    var body: some View {
        
        VStack {
            
            selectViewType
                .padding(.top, 40)
            
            viewType.view
                .padding(.horizontal, responsiveSize(0, 100))
            
            Spacer()
        }
        .background(CustomColor.background)
        .onAppear {
            AnalyticsLogger.logScreenTransition(viewName: MainViewName.root(.record))
        }
    }
}
