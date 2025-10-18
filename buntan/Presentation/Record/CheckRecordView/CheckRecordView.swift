//
//  CheckRecordView.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/09.
//

import SwiftUI

struct CheckRecordView: View {
    @State var viewModel: CheckRecordViewViewModel
    
    init(viewModel: CheckRecordViewViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Picker("grade", selection: Binding(
                get: { viewModel.state.selectedGrade },
                set: { newValue in viewModel.send(.selectGrade(newValue))}
            )) {
                ForEach(EikenGrade.allCases, id: \.self) { grade in
                    Text(grade.title)
                        .fontSize(responsiveSize(16, 20))
                }
            }
            .background(Orange.semiClear.cornerRadius(10))
            .padding(.top, 12)
            
            ChartRangePicker(
                label: viewModel.state.offsetCount == 0 ? "直近の記録" : "過去の記録",
                rightButtonDisabled: viewModel.state.rightButtonDisabled,
                leftButtonDisabled: viewModel.state.leftButtonDisabled
            ) { buttonType in
                viewModel.send(.didPickerButtonTapped(buttonType))
            }
            .font(.system(size: 14))
            .foregroundColor(.black)
            .padding(.top, 10)
            
            CheckRecordChart(
                correctPercentageData: viewModel.state.correctPercentageData,
                estimatedCountData: viewModel.state.estimatedCountData,
                ghostData: viewModel.state.ghostData
            )
            .overlay {
                if !viewModel.state.isLoading && viewModel.state.isSelectedGradeRecordsEmpty {
                    Text("表示可能な記録がありません")
                        .bold()
                        .foregroundColor(.black.opacity(0.7))
                }
            }
            .padding(.top, 32)
        }
        .task {
            viewModel.send(.task)
        }
    }
}
