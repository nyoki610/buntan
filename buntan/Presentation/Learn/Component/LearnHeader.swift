//
//  LearnHeader.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/19.
//

import SwiftUI

struct LearnHeader: View {
    let headerLabel: String
    let correctRatio: Double
    let incorrectRatio: Double
    let width: CGFloat
    let xmarkButtonAction: () -> Void

    enum Const {
        static let progressRectangleHeight: CGFloat = 8.0
    }

    var body: some View {
        HStack(spacing: 0) {
            Button {
                xmarkButtonAction()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: responsiveSize(18, 24)))
                    .foregroundColor(.black)
                    .fontWeight(.bold)
            }

            Spacer()

            Text(headerLabel)
                .fontSize(responsiveSize(20, 28))
                .foregroundColor(.black.opacity(0.8))
                .bold()

            Spacer()

        }
        .padding(.vertical, responsiveSize(20, 40))
        .padding(.horizontal, 30)
        .background(.white)
        .overlay(
            learnProgressView(),
            alignment: .bottom
        )
    }

    private func learnProgressView() -> some View {
        ZStack {
            Rectangle()
                .frame(height: 2.0)
                .foregroundColor(CustomColor.headerGray)

            HStack(spacing: 0) {
                Rectangle()
                    .frame(
                        width: width * correctRatio,
                        height: Const.progressRectangleHeight
                    )
                    .cornerRadius(3)
                    .foregroundColor(RoyalBlue.defaultRoyal)

                Spacer()

                Rectangle()
                    .frame(
                        width: width * incorrectRatio,
                        height: Const.progressRectangleHeight
                    )
                    .cornerRadius(3)
                    .foregroundColor(Orange.defaultOrange)
            }
        }
    }
}
