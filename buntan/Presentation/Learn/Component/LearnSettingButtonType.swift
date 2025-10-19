//
//  LearnSettingButtonType.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/19.
//

import SwiftUI

enum LearnSettingButtonType {
    case shuffle(Binding<Bool>, () -> Void)
    case readOut(Binding<Bool>)
    case showSentence(Binding<Bool>)
    case showInitial(Binding<Bool>)
}

extension LearnSettingButtonType: Identifiable {
    var id: String { UUID().uuidString }
}

struct LearnSettingButtonConfig {
    let label: String
    let subLabel: String?
    let systemName: String
    let isOn: Binding<Bool>
    let onTapAction: (() -> Void)?
    
    init(
        label: String,
        subLabel: String?,
        systemName: String,
        isOn: Binding<Bool>,
        onTapAction: (() -> Void)? = nil
    ) {
        self.label = label
        self.subLabel = subLabel
        self.systemName = systemName
        self.isOn = isOn
        self.onTapAction = onTapAction
    }
}

extension LearnSettingButtonType {
    var config: LearnSettingButtonConfig {
        switch self {
        case let .shuffle(isOn, onTapAction):
            return .init(
                label: "シャッフル",
                subLabel: nil,
                systemName: "shuffle",
                isOn: isOn,
                onTapAction: onTapAction
            )
        
        case let .readOut(isOn):
            return .init(
                label: "音声を",
                subLabel: "自動再生",
                systemName: "speaker.wave.2.fill",
                isOn: isOn
            )
            
        case let .showSentence(isOn):
            return .init(
                label: "例文を",
                subLabel: "表示",
                systemName: "textformat.abc",
                isOn: isOn
            )
            
        case let .showInitial(isOn):
            return .init(
                label: "イニシャルを",
                subLabel: "表示",
                systemName: "character",
                isOn: isOn
            )
        }
    }
}
