//
//  ForcedUpdateView.swift
//  buntan
//
//  Created by 二木裕也 on 2025/09/19.
//

import SwiftUI

struct ForcedUpdateView: View {
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.blue)
                Text("アップデートのお知らせ")
                    .font(.headline)
                    .fontWeight(.bold)
            }
            
            Image("BuntanIcon")
                .resizable()
                .frame(width: 120, height: 120)
                .padding(.vertical, 12)
            
            VStack {
                Text("アプリを引き続きご利用いただくためには")
                Text("アップデートが必要です。")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)

            StartButton(label: "App Storeを開く →", color: .blue) {
                let contactFormURL = "https://x.gd/R38a3"
                guard let url = URL(string: contactFormURL) else { return }
                UIApplication.shared.open(url)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 25)
        .background(.white)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 10)
        .onAppear {
            AnalyticsLogger.logScreenTransition(viewName: MainViewName.forcedUpdate)
        }
    }
}

#Preview {
    ForcedUpdateView()
}
