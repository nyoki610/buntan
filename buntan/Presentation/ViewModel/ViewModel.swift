//
//  ViewModel.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/05.
//

import Foundation

@MainActor
protocol ViewModel {
    associatedtype Argument
    associatedtype Dependency
    associatedtype State
    associatedtype BindingState
    associatedtype Action
    associatedtype Error

    var argument: Argument { get }
    var dependency: Dependency { get }
    var state: State { get }
    var binding: BindingState { get }
    var error: Error? { get }

    func send(_ action: Action)
}

extension ViewModel where Argument == Void {
    var argument: Argument { () }
}

extension ViewModel where Action == Never {
    func send(action: Action) {}
}

extension ViewModel where BindingState == Void {
    var binding: BindingState { () }
}

extension ViewModel where Error == Never {
    var error: Error? { nil }
}
