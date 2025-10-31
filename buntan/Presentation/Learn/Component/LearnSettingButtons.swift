//
//  LearnSettingButtons.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/19.
//

import SwiftUI

struct LearnSettingButtons: View {
    let buttonTypes: [LearnSettingButtonType]
    @Binding var showSetting: Bool

    var body: some View {
        if showSetting {
            HStack(spacing: 0) {
                ForEach(buttonTypes) { type in
                    Spacer()
                    settingButton(for: type)
                }
                Spacer()
            }
        } else {
            HStack(spacing: 0) {
                Spacer()
                Button {
                    withAnimation(.easeOut(duration: 0.2)) {
                        showSetting = true
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.down")
                        Text("設定を表示")
                    }
                    .font(.system(size: responsiveSize(16, 24)))
                    .fontWeight(.bold)
                    .foregroundStyle(.black.opacity(0.8))
                }
            }
            .padding(.top, 10)
            .padding(.horizontal, responsiveSize(20, 40))
        }
    }

    private func settingButton(for type: LearnSettingButtonType) -> some View {
        HStack(spacing: 12) {
            VStack(spacing: 0) {
                Image(systemName: type.config.systemName)
                    .font(.system(size: responsiveSize(20, 28)))
                VStack(spacing: 0) {
                    Text(type.config.label)
                    if let subLabel = type.config.subLabel {
                        Text(subLabel)
                    }
                }
                .font(.system(size: responsiveSize(20, 28) / 1.8))
                .padding(.top, 4)
            }
            .foregroundStyle(.black)
            .fontWeight(.bold)
            .padding(.trailing, 4)

            CustomToggle(
                isOn: type.config.isOn,
                color: Orange.egg,
                scale: responsiveSize(1.0, 1.3),
                action: type.config.didTapped
            )
        }
    }
}
