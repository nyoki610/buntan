import SwiftUI
import Charts

extension CheckRecordView {
    
    var extractedRecords: [CheckRecord] {
        checkRecords.filter { $0.grade == selectedGrade}.reversed()
    }
    
    var prefixedRecords: [CheckRecord] { Array(extractedRecords.dropFirst(chartController * 10).prefix(10)) }
    
    var recentCheckRecords: [CheckRecord] {
        
        var recentCheckRecords = prefixedRecords
        
        for _ in 0..<10 - prefixedRecords.count {
            recentCheckRecords.append(EmptyModel.checkRecord)
        }
        return recentCheckRecords
    }
    
    @ViewBuilder
    var chartView: some View {

        let value1Range: ClosedRange<Double> = 0...100
        let value2Range: ClosedRange<Double> = 0...EikenGrade.first.questionCount.double
        let graphRange: ClosedRange<Double> = 0...100

        let indexedRecords = recentCheckRecords.enumerated().map { IndexedCheckRecord(index: $0.offset + 1 + chartController * 10, record: $0.element) }.reversed()
        
        Chart(indexedRecords) { indexedRecord in
            
            let correctPercentage = indexedRecord.record.correctCount.double / EikenGrade.first.questionCount.double * 100
            let estimatedCount = Double(indexedRecord.record.estimatedCount)
            
            let value1 = map(correctPercentage, in: value1Range, to: graphRange)
            let value2 = map(estimatedCount, in: value2Range, to: graphRange)
            
            if indexedRecord.record.id != "" {
                
                LineMark(x: .value("Index", indexedRecord.index.string),
                         y: .value("CorrectPercetage", value1),
                         series: .value("CorrectPercetage", "CorrectPercetage"))
                .foregroundStyle(Orange.translucent)
                
                PointMark(x: .value("Index", indexedRecord.index.string),
                          y: .value("CorrectPercetage", value1))
                .symbol(.circle)
                .foregroundStyle(Orange.defaultOrange)
                .annotation(position: .top) {
                    Text(value1 >= value2 ? indexedRecord.record.date.monthDayString : "")
                        .fontSize(responsiveSize(8, 14))
                        .foregroundColor(.black.opacity(0.7))
                }
                
                LineMark(x: .value("Index", indexedRecord.index.string),
                         y: .value("EstimatedCount", value2),
                         series: .value("EstimatedCount", "EstimatedCount"))
                .foregroundStyle(RoyalBlue.translucent)
                
                PointMark(x: .value("Index", indexedRecord.index.string),
                          y: .value("EstimatedCount", value2))
                .symbol(.circle)
                .foregroundStyle(RoyalBlue.defaultRoyal)
                .annotation(position: .top) {
                    Text(value1 < value2 ? indexedRecord.record.date.monthDayString : "")
                        .fontSize(responsiveSize(8, 14))
                        .foregroundColor(.black.opacity(0.7))
                }
            } else {
                PointMark(
                    x: .value("Index", indexedRecord.index.string),
                    y: .value("correctPercentage", correctPercentage)
                )
                .foregroundStyle(.clear)
            }
        }
        .chartYAxis(content: {
            let value1AxisValue = stride(from: value1Range.lowerBound, through: value1Range.upperBound, by: 10)
                .map({ map($0, in: value1Range, to: graphRange) })
            AxisMarks(position: .trailing, values: value1AxisValue, content: { axis in
                let actualValue = map(value1AxisValue[axis.index], in: graphRange, to: value1Range)
                AxisValueLabel("\(actualValue.formatted(.number))")
                    .foregroundStyle(Orange.defaultOrange)
                AxisGridLine(stroke: .init(lineWidth: 0.5, dash: [2], dashPhase: 2)).foregroundStyle(Orange.defaultOrange)
            })
            let value2AxisValues = stride(from: value2Range.lowerBound, through: value2Range.upperBound, by: 2)
                .map({ map($0, in: value2Range, to: graphRange) })
            AxisMarks(position: .leading, values: value2AxisValues, content: { axis in
                let actualValue = map(value2AxisValues[axis.index], in: graphRange, to: value2Range)
                AxisValueLabel("\(actualValue.formatted(.number))")
                    .foregroundStyle(RoyalBlue.defaultRoyal)
                AxisGridLine(stroke: .init(lineWidth: 0.5, dash: [2], dashPhase: 2)).foregroundStyle(RoyalBlue.defaultRoyal)
            })
        })
        .chartYAxisLabel(position: .trailing, alignment: .center, spacing: 4) {
            Text("カバー率 (%)")
                .font(.system(size: responsiveSize(12, 20)))
                .bold()
        }
        .chartYAxisLabel(position: .leading, alignment: .center, spacing: 4) {
            Text("推定得点 (問)")
                .font(.system(size: responsiveSize(12, 20)))
                .bold()
        }
    }
    
    private func map(_ value: Double, in range: ClosedRange<Double>, to toRange: ClosedRange<Double>) -> Double {
        let ratio = range.ratio(for: value)
        return toRange.value(from: ratio)
    }
    
    struct IndexedCheckRecord: Identifiable {
        let id = UUID()
        let index: Int
        let record: CheckRecord
    }
}

extension ClosedRange where Bound == Double {
    func ratio(for value: Bound) -> Bound {
        return (value - self.lowerBound) / (self.upperBound - self.lowerBound)
    }

    func value(from ratio: Bound) -> Bound {
        return self.lowerBound + (self.upperBound - self.lowerBound) * ratio
    }
}
