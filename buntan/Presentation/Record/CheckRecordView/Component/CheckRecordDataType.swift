//
//  CheckRecordDataType.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/11.
//

import SwiftUI

enum CheckRecordDataType: String {
    case correctPercentage
    case estimatedPoint
    case ghost
    
    var marksConfig: ChartMarksConfig {
        let xLabel = "index"
        let lineColor : Color = {
            switch self {
            case .correctPercentage: return Orange.translucent
            case .estimatedPoint: return RoyalBlue.translucent
            case .ghost: return .clear
            }
        }()
        let pointColor : Color = {
            switch self {
            case .correctPercentage: return Orange.defaultOrange
            case .estimatedPoint: return RoyalBlue.defaultRoyal
            case .ghost: return .clear
            }
        }()
        return .init(
            xLabel: xLabel,
            yLabel: rawValue,
            color: .init(
                line: lineColor,
                point: pointColor
            )
        )
    }
    
    func axisConfig(for grade: EikenGrade) -> ChartAxisConfig {
        let axisValues = axisValues(for: grade)
        switch self {
        case .correctPercentage:
            return .init(
                values: axisValues,
                color: Orange.defaultOrange,
                position: .trailing,
                valueToLabel: { axisValue in String(Int(axisValue.index * 10))}
            )
        case .estimatedPoint:
            return .init(
                values: axisValues,
                color: RoyalBlue.defaultRoyal,
                position: .leading,
                valueToLabel: { axisValue in String(Int(axisValues[axisValue.index])) }
            )
        case .ghost:
            return .init(
                values: axisValues,
                color: .clear,
                position: .leading,
                valueToLabel: { axisValue in String(Int(axisValues[axisValue.index])) }
            )
        }
    }
    
    private func axisValues(for grade: EikenGrade) -> [Double] {
        let upperBound: Double = {
            switch self {
            case .correctPercentage: return 100
            case .estimatedPoint: return grade.questionCount.double
            case .ghost: return 100
            }
        }()
        
        let strideStep: Double = {
            switch self {
            case .correctPercentage: return 10
            case .estimatedPoint: return 2
            case .ghost: return 10
            }
        }()
        
        return stride(from: 0, through: upperBound, by: strideStep)
            .map{ ($0 / upperBound) * 22 } /// Normalize the maximum value to 100
    }
}
