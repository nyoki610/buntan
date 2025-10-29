//
//  FlickSentenceCardView.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/25.
//

import SwiftUI

struct FlickSentenceCardView: View {
    let card: LearnCard
    let config: Config

    enum Config {
        case flick(
            isFlipped: Bool,
            // TODO: verify whether 'isFlippedWithNoAnimation' is truly necessary
            isFlippedWithNoAnimation: Bool,
            onTapGesture: () -> Void
        )
        case fourChoices
    }

    var body: some View {
        switch config {
        case .flick(let isFlipped, let isFlippedWithNoAnimation, let onTapGesture):
            VStack(spacing: 0) {
                if !isFlippedWithNoAnimation {
                    frontSide(
                        card: card,
                        isSentenceExist: !card.sentence.isEmpty && !card.translation.isEmpty
                    )
                } else {
                    backSide(
                        card: card,
                        isSentenceExist: !card.sentence.isEmpty && !card.translation.isEmpty
                    )
                }
            }
            .cardStyle(height: responsiveSize(160, 180))
            .rotation3DEffect(
                .degrees(isFlipped ? 180 : 0),
                axis: (x: 1, y: 0, z: 0)
            )
            .onTapGesture {
                onTapGesture()
            }
            
        case .fourChoices:
            VStack(spacing: 0) {
                frontSide(
                    card: card,
                    isSentenceExist: !card.sentence.isEmpty && !card.translation.isEmpty
                )
            }
            .cardStyle(height: responsiveSize(100, 180))
        }
    }
    
    private func frontSide(card: LearnCard, isSentenceExist: Bool) -> some View {
        let fontSize = {
            let iPhoneFontSize: CGFloat = {
                switch config {
                case .flick: 18
                case .fourChoices: 20
                }
            }()
            let iPadFontSize: CGFloat = 28
            return responsiveSize(iPhoneFontSize, iPadFontSize)
        }()
        return Group {
            if isSentenceExist {
                Text(
                    CustomText.boldSentence(
                        card: card,
                        size: fontSize,
                        isUnderlined: true
                    )
                )
                .font(.system(size: fontSize))
            } else {
                VStack(spacing: 12) {
                    Text("この単語の例文は準備中です")
                        .fontSize(responsiveSize(18, 24))
                    Text("次回アップデートをお待ちください")
                        .fontSize(responsiveSize(16, 20))
                }
                .foregroundColor(.gray)
                .fontWeight(.medium)
            }
        }
        .padding(.horizontal, 8)
    }
    
    private func backSide(card: LearnCard, isSentenceExist: Bool) -> some View {
        VStack(spacing: 12) {
            if isSentenceExist {
                Text(card.translation)
                    .font(.system(size: responsiveSize(16, 24)))
                    .lineLimit(3)
                    .rotation3DEffect(.degrees(-180), axis: (x: 1, y: 0, z: 0))
                Text(
                    CustomText.boldSentence(
                        card: card,
                        size: responsiveSize(16, 24),
                        isUnderlined: true
                    )
                )
                    .fontSize(responsiveSize(16, 24))
                    .lineLimit(3)
                    .rotation3DEffect(.degrees(-180), axis: (x: 1, y: 0, z: 0))
            } else {
                Text("例文は準備中です")
                    .fontSize(responsiveSize(16, 24))
                    .lineLimit(3)
                    .rotation3DEffect(.degrees(-180), axis: (x: 1, y: 0, z: 0))
            }
        }
    }
}


private enum CardConstants {
    static let cornerRadius: CGFloat = 5
    static let shadowRadius: CGFloat = 5
}

private extension View {
    func cardStyle(height: CGFloat) -> some View {
        self
            .padding(4)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)
            .frame(
                width: responsiveSize(300, 500),
                height: height
            )
            .cornerRadius(CardConstants.cornerRadius)
            .shadow(radius: CardConstants.shadowRadius)
    }
}
