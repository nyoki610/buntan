//
//  ContactView.swift
//  buntan
//
//  Created by 二木裕也 on 2025/09/15.
//

import SwiftUI

struct ContactView: View {
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.blue)
                Text("お問い合わせ")
                    .font(.headline)
                    .fontWeight(.bold)
            }

            VStack {
                Text("不具合報告、アプリの感想、要望など")
                Text("何かお気づきの点がございましたら、")
                Text("以下のフォームよりお気軽にお知らせください。")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)

                let contactFormURL = "https://forms.gle/53ayTwLYKHkwusrt9"
                guard let url = URL(string: contactFormURL) else { return }
                UIApplication.shared.open(url)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 25)
        .background(.white)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 10)
    }
}

#Preview {
    ContactView()
}
