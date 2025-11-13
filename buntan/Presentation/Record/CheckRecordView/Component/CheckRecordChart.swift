//
//  CheckRecordChart.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/15.
//

import SwiftUI
import Charts

struct CheckRecordChart: View {
    let correctPercentageData: ChartData
    let estimatedCountData: ChartData
    let ghostData: ChartData?
    
    var body: some View {
        Chart {
            if let ghostData = ghostData {
                ChartPointMarks(
                    items: ghostData.items,
                    config: ghostData.marksConfig,
                    annotation: { _, _ in nil }
                )
            }
            
            ChartLineMarks(
                items: correctPercentageData.items,
                config: correctPercentageData.marksConfig
            )
            
            ChartPointMarks(
                items: correctPercentageData.items,
                config: correctPercentageData.marksConfig,
                annotation: { index, item in
                    annotation(at: index, item: item, forCorrectPercentage: true)
                }
            )
            
            ChartLineMarks(
                items: estimatedCountData.items,
                config: estimatedCountData.marksConfig
            )
            
            ChartPointMarks(
                items: estimatedCountData.items,
                config: estimatedCountData.marksConfig,
                annotation: { index, item in
                    annotation(at: index, item: item, forCorrectPercentage: false)
                }
            )
        }
        .chartYAxis {
            ChartAxisFactory.create(from: correctPercentageData.axisConfig)
            ChartAxisFactory.create(from: estimatedCountData.axisConfig)
        }
        .chartYAxisLabel(position: .trailing, alignment: .center, spacing: 4) {
            yAxisLabel(label: "カバー率 (%)")
        }
        .chartYAxisLabel(position: .leading, alignment: .center, spacing: 4) {
            yAxisLabel(label: "推定得点 (問)")
        }
        .padding(20)
        .frame(height: responsiveSize(340, 520))
        .background(.white)
        .cornerRadius(10)
        .padding(.horizontal, 10)
    }
    
    private func annotation(at index: Int, item: ChartPlotData, forCorrectPercentage: Bool) -> (any View)? {
        if shouldShowAnnotation(at: index, forCorrectPercentage: forCorrectPercentage) {
            return annotationLabel(label: item.annotationLabel)
        }
        return nil
    }
    
    private func shouldShowAnnotation(at index: Int, forCorrectPercentage: Bool) -> Bool {
        let correct = correctPercentageData.items[index].y
        let estimated = estimatedCountData.items[index].y
        return forCorrectPercentage ? (correct >= estimated) : (correct < estimated)
    }
    
    private func annotationLabel(label: String) -> some View {
        Text(label)
            .fontSize(responsiveSize(8, 14))
            .foregroundColor(.black.opacity(0.7))
    }
    
    private func yAxisLabel(label: String) -> some View {
        Text(label)
            .font(.system(size: responsiveSize(12, 20)))
            .bold()
    }
}
