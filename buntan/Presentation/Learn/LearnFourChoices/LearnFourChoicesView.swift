//
//  LearnFourChoicesView.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/20.
//

import SwiftUI

struct LearnFourChoicesView: View {
    typealias ViewModel = LearnFourChoicesViewViewModel
    
    @State private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                LearnHeader(
                    headerLabel: viewModel.uiOutput.headerLabel,
                    correctRatio: viewModel.uiOutput.correctRatio,
                    incorrectRatio: viewModel.uiOutput.incorrectRatio,
                    width: geometry.size.width,
                    xmarkButtonAction: {
                        Task { await viewModel.send(.didXmarkButtonTapped) }
                    }
                )

                Spacer().frame(height: 16)
                
                LearnSettingButtons(
                    buttonTypes: [
                        .shuffle(
                            $viewModel.userDefaultHandler.shouldShuffle,
                            didTapped: {
                                Task { await viewModel.send(.didShuffleButtonTapped) }
                            }
                        ),
                        .readOut($viewModel.userDefaultHandler.shouldReadOut),
                        .showSentence($viewModel.userDefaultHandler.showSentence)
                    ],
                    showSetting: Binding(
                        get: { viewModel.state.showSetting },
                        set: { _ in Task { await viewModel.send(.toggleShowSetting) }}
                    )
                )
                
                Spacer()
                
                if viewModel.userDefaultHandler.showSentence {
                    FlickWordCardView(
                        card: viewModel.state.currentCard,
                        config: .fourChoices
                    )
                } else {
                    FlickSentenceCardView(
                        card: viewModel.state.currentCard,
                        config: .fourChoices
                    )
                }
                
                Spacer()
                
                LearnOptionView(
                    status: viewModel.state.optionStatus,
                    fourChoiceOptions: viewModel.state.currentOption,
                    didTapOption: { selectedOptionId in
                        Task { await viewModel.send(.selectOption(optionId: selectedOptionId)) }
                    }
                )
                
                Spacer()
                
                LearnBottomButtons(
                    leftButtonTypes: leftBottomButtonType,
                    rightButtonTypes: rightBottomButtonType
                )
            }
            .background(CustomColor.background)
            .navigationBarBackButtonHidden(true)
        }
    }
    
    private var leftBottomButtonType: [LearnBottomButtonType] {
        guard !viewModel.uiOutput.isInitialState else {
            return []
        }
        return [
            .back(
                didTapped: {
                    Task { await viewModel.send(.didBackButtonTapped) }
                }
            ),
            .backToStart(
                didTapped: {
                    Task { await viewModel.send(.didBackToStartButtonTapped) }
                }
            )
        ]
    }
    
    private var rightBottomButtonType: [LearnBottomButtonType] {
        [
            .readOut(
                isDisabled: (!viewModel.uiOutput.isAnswering || viewModel.state.isReadingOut),
                didTapped: {
                    Task { await viewModel.send(.didReadOutButtonTapped) }
                }
            ),
            .pass(
                didTapped: {
                    Task { await viewModel.send(.didPassButtonTapped) }
                }
            )
        ]
    }
}
