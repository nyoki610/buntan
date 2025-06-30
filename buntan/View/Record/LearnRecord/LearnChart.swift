import SwiftUI
import Charts

extension LearnRecordView {
    
    private var lastElementExist: Bool { dailyLearnRecords.last != nil }
    
    /// データを表示する7日のうち最初の日(日曜日)のDateを返す
    /// 基準 : latestDateの直近の日曜日
    /// 遡る日数 : 7 * chartController
    var firstDate: Date {
        Calendar.current.date(byAdding: .day,
                              value: -7 * chartController,
                              to: latestData.previousSunday) ?? Date()
    }
    
    /// LearnRecordが存在する最も古い日付
    var lastDate: Date {
        dailyLearnRecords.first?.date ?? Date()
    }
    
    /// LearnRecordが存在する最も新しい日付
    var latestData: Date {
        dailyLearnRecords.last?.date ?? Date()
    }
       
    private var sevenDaysRecord: [LearnRecord] {
        
        // what for?
        guard lastElementExist else { return [] }
        
        let filteredRecords = dailyLearnRecords.filter {
            $0.date >= firstDate && $0.date <= firstDate.afterSevenDays
        }

        return (0..<7).map { dayOffset in
            let targetDate = Calendar.current.date(byAdding: .day, value: Int(dayOffset), to: firstDate)!
            return filteredRecords
                .first { Calendar.current.isDate($0.date, inSameDayAs: targetDate) } ??
            LearnRecord(
                id: UUID().uuidString,
                date: targetDate,
                learnedCardCount: 0
            )
        }
    }
    
    var maxCount: Int { sevenDaysRecord.map { $0.learnedCardCount }.max() ?? 0 }
    private var fixedMaxCount: Int { maxCount >= 100 ? Int(pow(10.0, ceil(log10(Double(maxCount))))) : 100 }
    
    @ViewBuilder
    var chartView: some View {
        
        Chart(sevenDaysRecord) { record in
            BarMark(
                x: .value("Date", record.date.monthDayString),
                y: .value("Count", record.learnedCardCount),
                width: 15
            )
            .foregroundStyle(Orange.defaultOrange)
            .annotation(position: .top) {
                Text("\(record.learnedCardCount.nonZeroString)")
                    .foregroundColor(.black.opacity(0.7))
                    .font(.system(size: responsiveSize(10, 16)))
            }
        }
        .chartYScale(
            domain: 0...fixedMaxCount
        )
        .chartYAxis {
            AxisMarks(values: .automatic(desiredCount: 10)) { value in
                AxisGridLine()
                if let yValue = value.as(Int.self) {
                    AxisValueLabel("\(yValue)")
                }
            }
        }
        .chartYAxisLabel(position: .trailing, alignment: .center, spacing: 4) {
            Text("学習した問題数")
                .font(.system(size: responsiveSize(12, 20)))
                .bold()
        }
    }
}
