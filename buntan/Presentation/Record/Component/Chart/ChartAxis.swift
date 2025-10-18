//
//  ChartAxis.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/17.
//

import SwiftUI
import Charts

struct ChartAxisConfig {
    let values: [Double]
    let color: Color
    let position: AxisMarkPosition
    let valueToLabel: (AxisValue) -> String
}

enum ChartAxisFactory {
    static func create(from config: ChartAxisConfig) -> some AxisContent {
        AxisMarks(
            position: config.position,
            values: config.values,
            content: { axisValue in
                AxisValueLabel(config.valueToLabel(axisValue))
                    .foregroundStyle(config.color)
                AxisGridLine(
                    stroke: .init(lineWidth: 0.5, dash: [2], dashPhase: 2)
                ).foregroundStyle(config.color)
            }
        )
    }
}
