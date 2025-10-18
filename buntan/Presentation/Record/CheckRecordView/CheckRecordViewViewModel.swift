//
//  CheckRecordViewViewModel.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/09.
//

import Foundation

@MainActor
@Observable
final class CheckRecordViewViewModel: ViewModel {
    typealias Argument = Void
    typealias BindingState = Void

    struct Dependency {
        let checkRecordService: any CheckRecordServiceProtocol
        
        init(checkRecordService: any CheckRecordServiceProtocol = CheckRecordService()) {
            self.checkRecordService = checkRecordService
        }
    }

    struct State {
        var isLoading = true
        var offsetCount: Int = 0
        var selectedGrade: EikenGrade = .first
        var chartState = CheckRecordChartState()
        
        var rightButtonDisabled: Bool { offsetCount <= 0 }
        var leftButtonDisabled: Bool {
            let selectedGradeRecords = chartState
                .checkRecords
                .filter { $0.grade == selectedGrade }
            let displayedRecordsCount = (offsetCount + 1) * 10
            return selectedGradeRecords.count <= displayedRecordsCount
        }
        var isSelectedGradeRecordsEmpty: Bool {
            chartState.isRecordsEmpty(for: selectedGrade)
        }
        var correctPercentageData: ChartData {
            chartState.chartData(for: selectedGrade, offsetCount: offsetCount, type: .correctPercentage)
        }
        var estimatedCountData: ChartData {
            chartState.chartData(for: selectedGrade, offsetCount: offsetCount, type: .estimatedPoint)
        }
        var ghostData: ChartData? {
            leftButtonDisabled ? chartState.ghostData(for: selectedGrade) : nil
        }
    }
    
    enum Action {
        case task
        case selectGrade(EikenGrade)
        case didPickerButtonTapped(ChartRangePicker.ButtonType)
    }
    
    @ObservationIgnored let dependency: Dependency
    private(set) var state = State()
    private(set) var error: Error?
    
    init(dependency: Dependency = .init()) {
        self.dependency = dependency
    }
    
    func send(_ action: Action) {
        do {
            switch action {
            case .task:
                state.chartState.checkRecords = try dependency.checkRecordService.getCheckRecords()
                    .sorted { $0.date > $1.date }
                state.isLoading = false
 
            case let .selectGrade(grade):
                state.selectedGrade = grade
                state.offsetCount = 0
                
            case let .didPickerButtonTapped(buttonType):
                switch buttonType {
                case .left: state.offsetCount += 1
                case .right: state.offsetCount -= 1
                }
            }
        } catch {
            self.error = error
        }
    }
}
