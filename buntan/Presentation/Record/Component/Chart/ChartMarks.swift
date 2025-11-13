//
//  ChartMarks.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/17.
//

import SwiftUI
import Charts

// MARK: - Config
struct ChartMarksConfig {
    let xLabel: String
    let yLabel: String
    let color: MarkColor
    var series: PlottableValue<String> { .value(yLabel, yLabel) }
    
    struct MarkColor {
        let bar: Color
        let line: Color
        let point: Color
        
        init(
            bar: Color = .clear,
            line: Color = .clear,
            point: Color = .clear
        ) {
            self.bar = bar
            self.line = line
            self.point = point
        }
    }
}

// MARK: - Marks
struct ChartBarMarks: ChartContent {
    let items: [ChartPlotData]
    let config: ChartMarksConfig
    let width: MarkDimension
    let annotation: (String) -> (any View)?

    init(
        items: [ChartPlotData],
        config: ChartMarksConfig,
        width: MarkDimension,
        xLabel: ((Double) -> String)? = nil,
        annotation: @escaping (String) -> (any View)?
    ) {
        self.items = items
        self.config = config
        self.width = width
        self.annotation = annotation
    }
    
    var body: some ChartContent {
        ForEach(items) { item in
            BarMark(
                x: .value(config.xLabel, item.x),
                y: .value(config.yLabel, item.y),
                width: width
            )
            .foregroundStyle(config.color.bar)
            .annotation(position: .top) {
                if let annotation = annotation(item.annotationLabel) {
                    AnyView(annotation)
                }
            }
        }
    }
}

struct ChartLineMarks: ChartContent {
    let items: [ChartPlotData]
    let config: ChartMarksConfig

    init(
        items: [ChartPlotData],
        config: ChartMarksConfig
    ) {
        self.items = items
        self.config = config
    }
    
    var body: some ChartContent {
        ForEach(items) { item in
            LineMark(
                x: .value(config.xLabel, item.x),
                y: .value(config.yLabel, item.y),
                series: config.series
            )
            .foregroundStyle(config.color.line)
        }
    }
}

struct ChartPointMarks: ChartContent {
    let items: [ChartPlotData]
    let config: ChartMarksConfig
    let annotation: (Int, ChartPlotData) -> (any View)?

    init(
        items: [ChartPlotData],
        config: ChartMarksConfig,
        annotation: @escaping (Int, ChartPlotData) -> (any View)?
    ) {
        self.items = items
        self.config = config
        self.annotation = annotation
    }
    
    var body: some ChartContent {
        ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
            PointMark(
                x: .value(config.xLabel, item.x),
                y: .value(config.yLabel, item.y)
            )
            .foregroundStyle(config.color.point)
            .annotation(position: .top) {
                if let annotation = annotation(index, item) {
                    AnyView(annotation)
                }
            }
        }
    }
}
