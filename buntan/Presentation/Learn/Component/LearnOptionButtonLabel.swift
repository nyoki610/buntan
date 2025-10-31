//
//  LearnOptionButton.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/19.
//

import SwiftUI

struct LearnOptionButtonLabel: View {
    enum Status {
        case answering
        case showingFeedBack(isAnswerOption: Bool, isSelected: Bool)
    }
    let option: Option
    let status: Status

    var body: some View {
        ZStack {
            Text(option.meaning)
                .foregroundColor(.black)
                .font(.system(size: responsiveSize(20, 28)))
                .lineLimit(1)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            if case .showingFeedBack(let isAnswerOption, let isSelected) = status, isSelected {
                HStack(spacing: 0) {
                    Image(systemName: isAnswerOption ? "circle" : "xmark")
                        .font(.system(size: responsiveSize(30, 40)))
                        .foregroundStyle(isAnswerOption ? Orange.defaultOrange : RoyalBlue.defaultRoyal)
                        .fontWeight(.bold)
                        .padding(.leading, responsiveSize(18, 24))
                    Spacer()
                }
            }
        }
        .background(.white)
        .frame(width: responsiveSize(280, 340), height: responsiveSize(60, 80))
        .cornerRadius(40)
        .shadow(radius: 2)
        .overlay(overlayContent())
    }

    @ViewBuilder
    private func overlayContent() -> some View {
        if case let .showingFeedBack(isAnswerOption, isSelected) = status {
            feedBackOverlay(isAnswerOption: isAnswerOption, isSelected: isSelected)
        } else {
            EmptyView()
        }
    }

    private func feedBackOverlay(isAnswerOption: Bool, isSelected: Bool) -> some View {
        let backgroundColor = isAnswerOption ? Orange.semiClear : isSelected ? RoyalBlue.semiClear : .clear
        let borderColor = isAnswerOption ? Orange.translucent : isSelected ? RoyalBlue.translucent : .clear
        return ZStack {
            backgroundColor
                .cornerRadius(40)
            RoundedRectangle(cornerRadius: 40)
                .stroke(borderColor, lineWidth: 4)
        }
    }
}
