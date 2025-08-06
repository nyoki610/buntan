//
//  BookSelectViewState.swift
//  buntan
//
//  Created by 二木裕也 on 2025/08/06.
//

import Foundation
import Combine

// MARK: - State Machine Protocol
/// 汎用的なStateMachineの基本構造を定義するプロトコル
/// このプロトコルを採用することで、一貫したStateMachineの実装が可能
protocol StateMachine {
    /// 状態の型を定義する関連型
    associatedtype State
    /// アクションの型を定義する関連型
    associatedtype Action
    
    /// 現在の状態を取得するプロパティ
    var currentState: State { get }
    /// 状態変更を監視するためのPublisher（Combineを使用）
    var statePublisher: AnyPublisher<State, Never> { get }
    /// アクションを送信して状態遷移を実行するメソッド
    func send(_ action: Action)
}

// MARK: - BookSelectView State Machine
/// 本選択画面の状態管理を行うStateMachine
/// StateMachineプロトコルとObservableObjectを採用し、SwiftUIで使用可能
class BookSelectViewStateMachine: StateMachine, ObservableObject {
    
    // MARK: - State Definition
    /// 本選択画面の状態を定義するenum
    /// Equatableプロトコルを採用して状態の比較を可能にする
    enum State: Equatable {
        /// 回答待ち状態（初期状態）
        /// ユーザーが問題に対して回答を入力する状態
        case waitingForAnswer
        
        /// 回答処理中状態
        /// ユーザーの回答を受け取り、結果を表示している状態
        /// 関連値としてAnswerResultを持つ
        case processingAnswer(AnswerResult)
        
        /// 完了状態
        /// 一連の処理が完了し、次のアクションを待つ状態
        case completed
        
        /// 回答結果を表す内部enum
        enum AnswerResult: Equatable {
            /// 正解
            case correct
            /// 不正解
            case incorrect
        }
        
        /// StateMachineの初期状態を返すstatic変数
        /// 常に回答待ち状態から開始する
        static var initialState: State {
            return .waitingForAnswer
        }
    }
    
    // MARK: - Action Definition
    /// ユーザーが実行可能なアクションを定義するenum
    /// これらのアクションが状態遷移のトリガーとなる
    enum Action {
        /// 回答を送信するアクション
        /// 関連値として正解かどうかのBool値を持つ
        case submitAnswer(isCorrect: Bool)
        
        /// 戻るボタンをタップするアクション
        /// 通常は処理完了後に次の画面に進む際に使用
        case tapBackButton
        
        /// パスボタンをタップするアクション
        /// 問題をスキップする際に使用（不正解として扱われる）
        case tapPassButton
        
        /// 状態をリセットするアクション
        /// どの状態からでも初期状態に戻すことができる
        case reset
    }
    
    // MARK: - Properties
    
    /// 現在の状態を保持するプロパティ
    /// @Publishedにより状態変更時にSwiftUIのViewが自動更新される
    /// private(set)により外部からの直接変更を防止
    @Published private(set) var currentState: State
    
    /// アクションを受信するためのCombineのSubject
    /// PassthroughSubjectを使用して、アクションが送信された時点で即座に処理
    private let actionSubject = PassthroughSubject<Action, Never>()
    
    /// Combineのsubscriptionを管理するためのSet
    /// メモリリークを防ぐためにsubscriptionを適切に管理
    private var cancellables = Set<AnyCancellable>()
    
    /// 外部から状態変更を監視するためのPublisher
    /// $currentStateにより@PublishedプロパティをPublisherとして公開
    var statePublisher: AnyPublisher<State, Never> {
        $currentState.eraseToAnyPublisher()
    }
    
    // MARK: - Initializer
    
    /// StateMachineのイニシャライザ
    /// - Parameter initialState: 初期状態（デフォルトは.initialState）
    init(initialState: State = .initialState) {
        self.currentState = initialState
        // アクション処理の設定を初期化時に実行
        setupActionHandling()
    }
    
    // MARK: - Public Methods
    
    /// アクションを送信するメソッド（StateMachineプロトコルの実装）
    /// このメソッドを通じて全ての状態遷移が実行される
    /// - Parameter action: 実行するアクション
    func send(_ action: Action) {
        actionSubject.send(action)
    }
    
    // MARK: - Private Methods
    
    /// アクション処理のセットアップを行うメソッド
    /// Combineを使用してアクションストリームを監視し、状態遷移を実行
    private func setupActionHandling() {
        actionSubject
            .sink { [weak self] action in
                // weak selfを使用してメモリリークを防止
                guard let self = self else { return }
                
                // 現在の状態を保存（副作用処理で使用）
                let previousState = self.currentState
                
                // reduceメソッドを使用して新しい状態を計算
                let newState = self.reduce(currentState: previousState, action: action)
                
                // メインスレッドで状態更新と副作用処理を実行
                // SwiftUIのUI更新はメインスレッドで行う必要があるため
                DispatchQueue.main.async {
                    self.currentState = newState
                    self.handleSideEffects(for: newState, previousState: previousState, action: action)
                }
            }
            .store(in: &cancellables) // subscriptionをcancellablesに保存
    }
    
    /// 状態遷移ロジックを定義するreduceメソッド
    /// Redux/Elmアーキテクチャに基づいた純粋関数として実装
    /// - Parameters:
    ///   - currentState: 現在の状態
    ///   - action: 実行するアクション
    /// - Returns: 新しい状態
    private func reduce(currentState: State, action: Action) -> State {
        switch (currentState, action) {
        // 回答待ち状態で回答を送信した場合
        case (.waitingForAnswer, .submitAnswer(let isCorrect)):
            // 正解/不正解に応じてAnswerResultを作成
            let result: State.AnswerResult = isCorrect ? .correct : .incorrect
            // 回答処理中状態に遷移
            return .processingAnswer(result)
            
        // 回答処理中状態で戻るボタンをタップした場合
        case (.processingAnswer, .tapBackButton):
            // 完了状態に遷移
            return .completed
            
        // 回答待ち状態でパスボタンをタップした場合
        case (.waitingForAnswer, .tapPassButton):
            // パスは不正解として扱い、回答処理中状態に遷移
            return .processingAnswer(.incorrect)
            
        // どの状態からでもリセットアクションを受け付ける
        case (_, .reset):
            // 初期状態（回答待ち）に戻る
            return .waitingForAnswer
            
        // 回答処理中状態で新しい回答が送信された場合
        case (.processingAnswer, .submitAnswer):
            // 処理中の場合は新しい回答を無視し、現在の状態を維持
            return currentState
            
        // その他の無効な状態遷移
        default:
            // 無効な状態遷移の場合は現在の状態を維持
            // これにより予期しない状態変更を防ぐ
            return currentState
        }
    }
    
    // MARK: - Convenience Methods
    // 外部からの使いやすさを向上させるためのconvenienceメソッド群
    // 内部的にsend()メソッドを呼び出すラッパー関数
    
    /// 回答を送信するconvenienceメソッド
    /// - Parameter isCorrect: 回答が正解かどうか
    func submitAnswer(isCorrect: Bool) {
        send(.submitAnswer(isCorrect: isCorrect))
    }
    
    /// 戻るボタンをタップするconvenienceメソッド
    func tapBackButton() {
        send(.tapBackButton)
    }
    
    /// パスボタンをタップするconvenienceメソッド
    func tapPassButton() {
        send(.tapPassButton)
    }
    
    /// 状態をリセットするconvenienceメソッド
    func reset() {
        send(.reset)
    }
    
    // MARK: - State Queries
    // 現在の状態を判定するためのcomputed property群
    // SwiftUIのViewで条件分岐に使用される
    
    /// 現在が回答待ち状態かどうかを判定
    /// - Returns: 回答待ち状態の場合true
    var isWaitingForAnswer: Bool {
        if case .waitingForAnswer = currentState {
            return true
        }
        return false
    }
    
    /// 現在が回答処理中状態かどうかを判定
    /// - Returns: 回答処理中状態の場合true
    var isProcessingAnswer: Bool {
        if case .processingAnswer = currentState {
            return true
        }
        return false
    }
    
    /// 現在が完了状態かどうかを判定
    /// - Returns: 完了状態の場合true
    var isCompleted: Bool {
        if case .completed = currentState {
            return true
        }
        return false
    }
    
    /// 現在の回答結果を取得
    /// - Returns: 回答処理中状態の場合はAnswerResult、それ以外はnil
    var answerResult: State.AnswerResult? {
        if case .processingAnswer(let result) = currentState {
            return result
        }
        return nil
    }
    
    // MARK: - Reactive Extensions
    // Combineを活用したリアクティブプログラミングのための拡張機能
    
    /// 特定の状態への変更を監視するための汎用メソッド
    /// 状態変更を細かく監視したい場合に使用
    /// - Parameter targetState: 監視したい状態を判定するクロージャ
    /// - Returns: 指定した条件にマッチした値を流すPublisher
    func stateChanges<T>(to targetState: @escaping (State) -> T?) -> AnyPublisher<T, Never> {
        statePublisher
            .compactMap(targetState) // 条件にマッチした値のみを通す
            .removeDuplicates { _, _ in false } // 常に通知（必要に応じて調整）
            .eraseToAnyPublisher()
    }
    
    /// 回答結果の変更を監視するPublisher
    /// 正解/不正解の結果が出た時点で通知される
    /// UIでフィードバック表示やアニメーション実行に使用
    var answerResultPublisher: AnyPublisher<State.AnswerResult, Never> {
        stateChanges { state in
            if case .processingAnswer(let result) = state {
                return result
            }
            return nil
        }
    }
    
    /// 完了状態への変更を監視するPublisher
    /// 一連の処理が完了した時点で通知される
    /// 次の画面への遷移や統計の保存などに使用
    var completionPublisher: AnyPublisher<Void, Never> {
        stateChanges { state in
            if case .completed = state {
                return ()
            }
            return nil
        }
    }
    
    // MARK: - Side Effects Management
    // 副作用（サイドエフェクト）の管理
    // 状態遷移に伴って実行される処理（ログ、アニメーション、サウンドなど）
    
    /// 状態遷移のログ出力（デバッグ用）
    /// 開発時の状態遷移の追跡とデバッグに使用
    /// - Parameters:
    ///   - oldState: 遷移前の状態
    ///   - newState: 遷移後の状態
    ///   - action: 遷移のトリガーとなったアクション
    private func logStateTransition(from oldState: State, to newState: State, action: Action) {
        print("🔄 State Transition: \(oldState) --[\(action)]--> \(newState)")
    }
    
    /// 副作用を処理するためのメソッド
    /// 状態遷移時に自動実行される処理を定義
    /// - Parameters:
    ///   - newState: 遷移後の新しい状態
    ///   - previousState: 遷移前の状態
    ///   - action: 遷移のトリガーとなったアクション
    private func handleSideEffects(for newState: State, previousState: State, action: Action) {
        // 全ての状態遷移でログを出力
        logStateTransition(from: previousState, to: newState, action: action)
        
        // 新しい状態に応じた副作用の実行
        switch newState {
        case .processingAnswer(let result):
            // 回答処理時の副作用（アニメーション、サウンドなど）
            handleAnswerProcessing(result: result)
        case .completed:
            // 完了時の副作用
            handleCompletion()
        case .waitingForAnswer:
            // 完了状態からのリセット時のみ副作用を実行
            if case .completed = previousState {
                handleReset()
            }
        }
    }
    
    /// 回答処理時の副作用を処理
    /// 正解/不正解に応じたフィードバックを実行
    /// - Parameter result: 回答結果
    private func handleAnswerProcessing(result: State.AnswerResult) {
        // 実装例：回答結果に応じた処理
        // - 正解時：成功音再生、緑色のフィードバック表示、祝福アニメーション
        // - 不正解時：失敗音再生、赤色のフィードバック表示、振動フィードバック
        // 実際の実装では、AudioManagerやHapticsManagerなどを呼び出す
    }
    
    /// 完了時の副作用を処理
    /// 一連の処理完了時に実行される処理
    private func handleCompletion() {
        // 実装例：完了時の処理
        // - 学習統計の更新
        // - 次の問題の準備
        // - 進捗データの保存
        // - 達成バッジの確認
    }
    
    /// リセット時の副作用を処理
    /// 状態がリセットされた時に実行される処理
    private func handleReset() {
        // 実装例：リセット時の処理
        // - UI状態のクリア
        // - タイマーのリセット
        // - 一時的なデータの削除
        // - アニメーションの停止
    }
}
