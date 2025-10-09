import SwiftUI

struct RecordView: View {
    
    @State var viewType: CheckViewType = .learn
    @State var viewModel: RecordViewViewModel
    
    init(viewModel: RecordViewViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        VStack {
            
            selectViewType
                .padding(.top, 40)
            
            switch viewType {
            case .learn:
                LearnRecordView(viewModel: .init())
                    .padding(.horizontal, responsiveSize(0, 100))
            case .check:
                CheckRecordView()
                    .padding(.horizontal, responsiveSize(0, 100))
            }
            
            Spacer()
        }
        .background(CustomColor.background)
        .onAppear {
            AnalyticsLogger.logScreenTransition(viewName: MainViewName.root(.record))
        }
        .task {
            viewModel.send(.task)
        }
    }
}
