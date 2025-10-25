//
//  LearnBottomButtonType.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/19.
//

import SwiftUI

enum LearnBottomButtonType {
    case back(didTapped: () -> Void)
    case backToStart(didTapped: () -> Void)
    case readOut(isDisabled: Bool, didTapped: () -> Void)
    case pass(didTapped: () -> Void)
    case next(didTapped: () -> Void)
}

extension LearnBottomButtonType: Identifiable {
    var id: String { UUID().uuidString }
}

struct LearnBottomButtonConfig {
    let label: String
    let subLabel: String?
    let systemName: String
    let color: Color
    let isDisabled: Bool
    let didTapped: (() -> Void)
    
    init(
        label: String,
        subLabel: String?,
        systemName: String,
        color: Color = .black,
        isDisabled: Bool = false,
        didTapped: @escaping () -> Void
    ) {
        self.label = label
        self.subLabel = subLabel
        self.systemName = systemName
        self.color = color
        self.isDisabled = isDisabled
        self.didTapped = didTapped
    }
}

extension LearnBottomButtonType {
    var config: LearnBottomButtonConfig {
        switch self {
        case let .back(didTapped):
            return .init(
                label: "ひとつ",
                subLabel: "戻る",
                systemName: "arrowshape.turn.up.left",
                didTapped: didTapped
            )
            
        case let .backToStart(didTapped):
            return .init(
                label: "最初に",
                subLabel: "戻る",
                systemName: "arrowshape.turn.up.backward.2",
                didTapped: didTapped
            )
            
        case let .readOut(isDisabled, didTapped):
            return .init(
                label: "音声を",
                subLabel: "再生",
                systemName: "speaker.wave.2.fill",
                color: isDisabled ? .gray : .black,
                isDisabled: isDisabled,
                didTapped: didTapped
            )
            
        case let .pass(didTapped):
            return .init(
                label: "パス",
                subLabel: nil,
                systemName: "arrowshape.turn.up.right",
                didTapped: didTapped
            )
            
        case let .next(didTapped):
            return .init(
                label: "次へ",
                subLabel: nil,
                systemName: "arrowshape.turn.up.right.fill",
                color: RoyalBlue.defaultRoyal,
                didTapped: didTapped
            )
        }
    }
}
