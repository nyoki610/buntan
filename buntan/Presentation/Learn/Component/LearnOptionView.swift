//
//  LearnOptionView.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/20.
//

import SwiftUI

struct LearnOptionView: View {
    enum Status: Equatable {
        case answering
        case showingFeedBack(answerId: String, selectedId: String)
    }
    let status: Status
    let fourChoiceOptions: FourChoiceOptions
    let didTapOption: ((String) -> Void)

    var body: some View {
        VStack(spacing: 20) {
            ForEach(fourChoiceOptions.options) { option in
                Button {
                    didTapOption(option.id)
                } label: {
                    LearnOptionButtonLabel(
                        option: option,
                        status: optionStatus(for: option)
                    )
                }
                .disabled(status != .answering)
            }
        }
    }

    private func optionStatus(for option: Option) -> LearnOptionButtonLabel.Status {
        switch status {
        case .answering:
            return .answering

        case .showingFeedBack(let answerId, let selectedId):
            return .showingFeedBack(
                isAnswerOption: answerId == option.id,
                isSelected: selectedId == option.id
            )
        }
    }
}
