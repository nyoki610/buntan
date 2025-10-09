import SwiftUI

struct LearnRecordView: View {
    
    @State var viewModel: LearnRecordViewViewModel
    
    private var chartState: LearnChartState { viewModel.state.chartState }
    private var recordsContainer: DailyLearnRecordsContainer { viewModel.state.recordsContainer }
    
    init(viewModel: LearnRecordViewViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 12) {
            VStack(spacing: 8) {
                Text(chartState.yearString)
                    .foregroundColor(.black.opacity(0.7))
                    .font(.system(size: responsiveSize(14, 20)))
                    .bold()
                
                chartRangePicker(
                    weekStartDate: chartState.weekStartDate,
                    earliestDate: recordsContainer.earliest
                )
            }
            .padding(.top, 20)
            
            LearnChart(sevenDaysRecords: chartState.sevenDaysRecords)
                .overlay(alignment: .center) {
                    if recordsContainer.allCount == 0 {
                        Text("この期間の記録はありません")
                            .bold()
                            .foregroundColor(.black.opacity(0.7))
                    }
                }
            
            VStack(spacing: 12) {
                SummarySection(
                    title: "この週に学習した問題数",
                    wordCount: chartState.sevenDaysCount
                )
                
                SummarySection(
                    title: "これまでに学習した問題数",
                    wordCount: recordsContainer.allCount
                )
            }
            
            Spacer()
        }
        .task {
            viewModel.send(.task)
        }
    }
    
    private func chartRangePicker(weekStartDate: Date, earliestDate: Date) -> some View {
        let startDateString = weekStartDate.monthDayString
        let endDateString = weekStartDate.afterSevenDays.monthDayString
        let today = Date()
        return ChartRangePicker(
            label: "\(startDateString) 〜 \(endDateString)",
            rightButtonDisabled: weekStartDate >= today.beforeSevenDays,
            leftButtonDisabled: weekStartDate <= earliestDate,
            action: { buttonType in
                viewModel.send(.didPickerButtonTapped(buttonType))
            }
        )
    }
}
