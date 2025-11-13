//
//  LearnRecordChart.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/08.
//

import SwiftUI
import Charts

struct LearnRecordChart: View {
    let learnedCardsCountData: ChartData
    
    var body: some View {
        Chart {
            ChartBarMarks(
                items: learnedCardsCountData.items,
                config: learnedCardsCountData.marksConfig,
                width: 15,
                annotation: { annotationLabel in
                    Text(annotationLabel)
                        .foregroundColor(.black.opacity(0.7))
                        .font(.system(size: responsiveSize(12, 16)))
                }
            )
        }
        .chartYAxis {
            ChartAxisFactory.create(from: learnedCardsCountData.axisConfig)
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
