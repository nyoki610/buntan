//
//  FlickWordCardView.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/24.
//

import SwiftUI

struct FlickWordCardView: View {
    let card: LearnCard
    let config: Config

    enum Config {
        case flick(isFlipped: Bool, onTapGesture: () -> Void)
        case fourChoices
    }

    var body: some View {
        switch config {
        case .flick(let isFlipped, let onTapGesture):
            VStack(spacing: 0) {
                if isFlipped {
                    frontSide(card: card, showPhrase: false)
                } else {
                    backSide(card: card)
                }
            }
            .cardStyle()
            .rotation3DEffect(
                .degrees(isFlipped ? -180 : 0),
                axis: (x: 0, y: 1, z: 0)
            )
            .onTapGesture {
                onTapGesture()
            }
            
        case .fourChoices:
            frontSide(card: card, showPhrase: true)
                .cardStyle()
        }
    }
    
    private func frontSide(card: LearnCard, showPhrase: Bool) -> some View {
        VStack(spacing: 4) {
            Text(card.word)
                .fontSize(responsiveSize(30, 40))
                .fontWeight(.medium)
                .lineLimit(1)

            if showPhrase && !card.phrase.isEmpty {
                Text(card.phrase.parentheses())
                    .font(.system(size: responsiveSize(16, 24)))
                    .fontWeight(.medium)
                    .lineLimit(1)
            }
        }
    }
    
    private func backSide(card: LearnCard) -> some View {
        VStack(spacing: 8) {
            Text("【\(card.pos.jaLabel)】 \(card.meaning)")
                .font(.system(size: responsiveSize(20, 24)))
                .fontWeight(.medium)
                .lineLimit(2)

            if !card.phrase.isEmpty {
                Text("(\(card.phrase) で)")
                    .font(.system(size: responsiveSize(14, 18)))
                    .fontWeight(.medium)
                    .lineLimit(2)
            }
        }
        .rotation3DEffect(.degrees(-180), axis: (x: 0, y: 1, z: 0))
    }
}

private enum CardConstants {
    static let cornerRadius: CGFloat = 20
    static let shadowRadius: CGFloat = 5
}

private extension View {
    func cardStyle() -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)
            .frame(width: responsiveSize(280, 340), height: responsiveSize(100, 120))
            .cornerRadius(CardConstants.cornerRadius)
            .shadow(radius: CardConstants.shadowRadius)
    }
}
