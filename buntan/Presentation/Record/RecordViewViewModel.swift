//
//  RecordViewViewModel.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/08.
//

import Foundation

@MainActor
@Observable
final class RecordViewViewModel: ViewModel {
    typealias Argument = Void
    typealias BindingState = Void
    
    struct Dependency {
        let learnRecordService: any LearnRecordServiceProtocol
        
        init(learnRecordService: any LearnRecordServiceProtocol = LearnRecordService()) {
            self.learnRecordService = learnRecordService
        }
    }
    
    struct State {
        var dailyLearnRecords: [LearnRecord] = []
    }
    
    enum Action {
        case task
    }
    
    @ObservationIgnored let dependency: Dependency
    private(set) var state: State
    private(set) var error: Error?
    
    init(dependency: Dependency = .init()) {
        self.dependency = dependency
        self.state = .init()
    }
    
    func send(_ action: Action) {
        do {
            switch action {
            case .task:
                state.dailyLearnRecords = try dependency.learnRecordService.getDailyLearnRecords()
            }
        } catch {
            self.error = error
        }
    }
}
