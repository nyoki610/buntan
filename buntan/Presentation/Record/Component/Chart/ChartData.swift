//
//  ChartData.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/11.
//

import Foundation

struct ChartData {
    let marksConfig: ChartMarksConfig
    let axisConfig: ChartAxisConfig
    let items: [ChartPlotData]
}

enum ChartDataFactory {
    // MARK: - for LearnRecord
    static func create(sevenDaysRecords: [LearnRecord]) -> ChartData {
        let marksConfig = ChartMarksConfig(
            xLabel: "date",
            yLabel: "count",
            color: .init(bar: Orange.defaultOrange)
        )
        let maxAxisValue = calculateMaxAxisValue(from: sevenDaysRecords)
        let axisValues = generateAxisValues(maxValue: maxAxisValue)
        let axisConfig = ChartAxisConfig(
            values: axisValues,
            color: Orange.defaultOrange,
            position: .trailing,
            valueToLabel: { axisValue in String(Int(axisValues[axisValue.index])) }
        )
        let items = ChartPlotDataFactory.create(from: sevenDaysRecords)
        return .init(
            marksConfig: marksConfig,
            axisConfig: axisConfig,
            items: items
        )
    }
    
    private static func calculateMaxAxisValue(from records: [LearnRecord]) -> Int {
        let maxCount = records.map { $0.learnedCardCount }.max() ?? 0
        let baseMaxValue = 100
        guard maxCount >= baseMaxValue else {
            return baseMaxValue
        }
        return Int(pow(10.0, ceil(log10(Double(maxCount)))))
    }
    
    private static func generateAxisValues(maxValue: Int) -> [Double] {
        let divisions = 10
        let step = maxValue / divisions
        return stride(from: 0, through: maxValue, by: step).map { Double($0) }
    }
    
    // MARK: - for CheckRecord
    static func create(
        from records: [CheckRecord],
        for grade: EikenGrade,
        type: CheckRecordDataType,
        indexOffset: Int
    ) -> ChartData {
        let items = ChartPlotDataFactory.create(
            from: records,
            type: type,
            indexOffset: indexOffset
        )
        return .init(
            marksConfig: type.marksConfig,
            axisConfig: type.axisConfig(for: grade),
            items: items.reversed()
        )
    }
    
    static func createGhostForCheckRecord(
        for grade: EikenGrade,
        indexOffset: Int,
        count: Int
    ) -> ChartData {
        let ghost = CheckRecordDataType.ghost
        let ghostGenerator: () -> CheckRecord = {
            .init(id: UUID().uuidString, grade: grade, date: Date(), correctCount: 0, estimatedCount: 0)
        }
        let ghostRecords: [CheckRecord] = (0..<count).map { _ in ghostGenerator() }
        let items = ChartPlotDataFactory.create(
            from: ghostRecords,
            type: ghost,
            indexOffset: indexOffset
        )
        return .init(
            marksConfig: ghost.marksConfig,
            axisConfig: ghost.axisConfig(for: grade),
            items: items.reversed()
        )
    }
}
