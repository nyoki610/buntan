//
//  LearnBottomButtonType.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/19.
//

import SwiftUI

enum LearnBottomButtonType {
    case back(() -> Void)
    case backToStart(() -> Void)
    case readOut(isDisabled: Bool, (() -> Void))
    case pass(() -> Void)
    case next(() -> Void)
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
    let onTappedAction: (() -> Void)
    
    init(
        label: String,
        subLabel: String?,
        systemName: String,
        color: Color = .black,
        isDisabled: Bool = false,
        onTappedAction: @escaping () -> Void
    ) {
        self.label = label
        self.subLabel = subLabel
        self.systemName = systemName
        self.color = color
        self.isDisabled = isDisabled
        self.onTappedAction = onTappedAction
    }
}

extension LearnBottomButtonType {
    var config: LearnBottomButtonConfig {
        switch self {
        case let .back(onTappedAction):
            return .init(
                label: "ひとつ",
                subLabel: "戻る",
                systemName: "arrowshape.turn.up.left",
                onTappedAction: onTappedAction
            )
            
        case let .backToStart(onTappedAction):
            return .init(
                label: "最初に",
                subLabel: "戻る",
                systemName: "arrowshape.turn.up.backward.2",
                onTappedAction: onTappedAction
            )
            
        case let .readOut(isDisabled, onTappedAction):
            return .init(
                label: "音声を",
                subLabel: "再生",
                systemName: "speaker.wave.2.fill",
                color: isDisabled ? .gray : .black,
                isDisabled: isDisabled,
                onTappedAction: onTappedAction
            )
            
        case let .pass(onTappedAction):
            return .init(
                label: "パス",
                subLabel: nil,
                systemName: "arrowshape.turn.up.right",
                onTappedAction: onTappedAction
            )
            
        case let .next(onTappedAction):
            return .init(
                label: "次へ",
                subLabel: nil,
                systemName: "arrowshape.turn.up.right.fill",
                color: RoyalBlue.defaultRoyal,
                onTappedAction: onTappedAction
            )
        }
    }
}
