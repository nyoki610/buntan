import SwiftUI

struct RecordView: View {
    @State var viewModel: RecordViewViewModel
    
    init(viewModel: RecordViewViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 4) {
                viewSelectButton(
                    label: "学習の記録",
                    isSelected: viewModel.state.selectedViewType == .learn,
                    action: { viewModel.send(.didTapViewSelectPicker(.learn) )}
                )
                viewSelectButton(
                    label: "テストの記録",
                    isSelected: viewModel.state.selectedViewType == .check,
                    action: { viewModel.send(.didTapViewSelectPicker(.check) )}
                )
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 4)
            .background(.white)
            .cornerRadius(10)
            .padding(.top, 40)
            
            switch viewModel.state.selectedViewType {
            case .learn:
                LearnRecordView(viewModel: .init())
                    .padding(.horizontal, responsiveSize(0, 100))
            case .check:
                CheckRecordView(viewModel: .init())
                    .padding(.horizontal, responsiveSize(0, 100))
            }
            Spacer()
        }
        .background(CustomColor.background)
        .onAppear {
            AnalyticsLogger.logScreenTransition(viewName: MainViewName.root(.record))
        }
    }
    
    private func viewSelectButton(
        label: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            action()
        } label:{
            VStack {
                Text(label)
                    .font(.system(size: responsiveSize(16, 20)))
                    .bold()
            }
            .frame(width: responsiveSize(160, 200))
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .foregroundColor(isSelected ? .black : .gray)
            .background(isSelected ? Orange.translucent : .clear)
            .cornerRadius(10)
        }
    }
}
