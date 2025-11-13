//
//  PlotData.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/11.
//

import Charts
import SwiftUI

struct ChartPlotData: Identifiable {
    let id: String
    let x: String
    let y: Double
    let annotationLabel: String
}

enum ChartPlotDataFactory {
    // MARK: - for LearnRecord
    static func create(from sevenDaysRecords: [LearnRecord]) -> [ChartPlotData] {
        sevenDaysRecords.map { record in
            let id = UUID().uuidString
            let x = record.date.monthDayString
            let y = record.learnedCardCount
            let annotationLabel: String = {
                guard y != 0 else { return "" }
                return String(y)
            }()
            return .init(id: id, x: x, y: Double(y), annotationLabel: annotationLabel)
        }
    }
    
    // MARK: - for CheckRecord
    static func create(
        from checkRecords: [CheckRecord],
        type: CheckRecordDataType,
        indexOffset: Int
    ) -> [ChartPlotData] {
        checkRecords.enumerated().map { index, record in
            let id = UUID().uuidString
            let x = index + 1 + indexOffset
            let y: Double = {
                switch type {
                case .correctPercentage:
                    return record.correctCount.double
                case .estimatedPoint:
                    return record.estimatedCount.double
                case .ghost:
                    return 0
                }
            }()
            return .init(id: id, x: String(x), y: y, annotationLabel: record.date.monthDayString)
        }
    }
}
