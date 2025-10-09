//
//  LearnRecordView+LearnChart.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/08.
//

import SwiftUI
import Charts

extension LearnRecordView {
    struct LearnChart: View {
        private let sevenDaysRecords: [LearnRecord]
        private var fixedMaxCount: Int {
            let maxCount = sevenDaysRecords.map { $0.learnedCardCount }.max() ?? 0
            return maxCount >= 100 ? Int(pow(10.0, ceil(log10(Double(maxCount))))) : 100
        }
        
        init(sevenDaysRecords: [LearnRecord]) {
            self.sevenDaysRecords = sevenDaysRecords
        }
        
        var body: some View {
            Chart(sevenDaysRecords) { record in
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
            .chartYScale(domain: 0...fixedMaxCount)
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
            .padding(20)
            .frame(height: responsiveSize(340, 520))
            .background(.white)
            .cornerRadius(10)
            .padding(.horizontal, 10)
        }
    }
}
