//
//  LearnOptionView.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/20.
//

import SwiftUI

struct LearnOptionView: View {
    enum Status {
        case answering((String) -> Void)
        case showingFeedBack(answerId: String, selectedId: String)
    }
    let status: Status
    let options: [Option]
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(options) { option in
                switch status {
                case let .answering(onAnswerSelected):
                    Button {
                        onAnswerSelected(option.id)
                    } label: {
                        LearnOptionButtonLabel(
                            option: option,
                            status: .answering
                        )
                    }
                case .showingFeedBack(let answerId, let selectedId):
                    LearnOptionButtonLabel(
                        option: option,
                        status: .showingFeedBack(
                            isAnswerOption: answerId == option.id,
                            isSelected: selectedId == option.id
                        )
                    )
                }
            }
        }
    }
}
