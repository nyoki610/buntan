//
//  LearnBottomButtons.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/19.
//

import SwiftUI

struct LearnBottomButtons: View {
    let leftButtonTypes: [LearnBottomButtonType]
    let rightButtonTypes: [LearnBottomButtonType]
    
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 28) {
                ForEach(leftButtonTypes) { type in
                    bottomButton(for: type.config)
                }
            }
            Spacer()
            HStack(spacing: 28) {
                ForEach(rightButtonTypes) { type in
                    bottomButton(for: type.config)
                }
            }
        }
        .padding(.horizontal, responsiveSize(50, 140))
    }
    
    private func bottomButton(for config: LearnBottomButtonConfig) -> some View {
        Button {
            config.didTapped()
        } label: {
            VStack(spacing: 4) {
                Image(systemName: config.systemName)
                    .font(.system(size: responsiveSize(24, 36)))
                VStack(spacing: 4) {
                    Text(config.label)
                    Text(config.subLabel ?? "")
                }
                .font(.system(size: responsiveSize(24, 36)/2))
                .padding(.top, 4)
            }
            .fontWeight(.bold)
            .foregroundStyle(config.color)
        }
        .disabled(config.isDisabled)
    }
}
