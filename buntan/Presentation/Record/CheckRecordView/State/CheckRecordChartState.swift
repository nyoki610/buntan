//
//  CheckRecordChartState.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/10.
//

import Foundation

struct CheckRecordChartState {
    var checkRecords: [CheckRecord] = []
    
    func isRecordsEmpty(for grade: EikenGrade) -> Bool {
        let selectedGradeRecords = checkRecords.filter { $0.grade == grade }
        return selectedGradeRecords.isEmpty
    }
    
    func chartData(for grade: EikenGrade, offsetCount: Int, type: CheckRecordDataType) -> ChartData {
        let indexOffset = offsetCount * 10
        let records = checkRecords
            .filter { $0.grade == grade }
            .dropFirst(indexOffset)
            .prefix(10)
        let chartData = ChartDataFactory.create(
            from: Array(records),
            for: grade,
            type: type,
            indexOffset: indexOffset
        )
        return chartData
    }

    func ghostData(for grade: EikenGrade) -> ChartData {
        let count = {
            guard checkRecords.count != 0 else { return 10 }
            return 10 - (checkRecords.count % 10)
        }()
        let chartData = ChartDataFactory.createGhostForCheckRecord(
            for: grade,
            indexOffset: checkRecords.count,
            count: count
        )
        return chartData
    }
}
