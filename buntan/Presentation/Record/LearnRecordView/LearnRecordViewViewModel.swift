//
//  LearnRecordViewViewModel.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/08.
//

import Foundation

@MainActor
@Observable
final class LearnRecordViewViewModel: ViewModel {
    typealias Argument = Void
    typealias BindingState = Void

    struct Dependency {
        let learnRecordService: any LearnRecordServiceProtocol
        
        init(learnRecordService: any LearnRecordServiceProtocol = LearnRecordService()) {
            self.learnRecordService = learnRecordService
        }
    }

    struct State {
        var weekOffsetCount: Int = 0
        var recordsContainer = DailyLearnRecordsContainer()
        var chartState: LearnRecordChartState {
            .init(
                weekOffsetCount: weekOffsetCount,
                dailyLearnRecords: recordsContainer.dailyLearnRecords,
                latestSunday: recordsContainer.latest.previousSunday
            )
        }
        var learnedCardsCountData: ChartData { ChartDataFactory.create(sevenDaysRecords: chartState.sevenDaysRecords) }
    }
    
    enum Action {
        case task
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
                state.recordsContainer.dailyLearnRecords = try dependency.learnRecordService.getDailyLearnRecords()
                
            case let .didPickerButtonTapped(buttonType):
                switch buttonType {
                case .left: state.weekOffsetCount += 1
                case .right: state.weekOffsetCount -= 1
                }
            }
        } catch {
            self.error = error
        }
    }
}
