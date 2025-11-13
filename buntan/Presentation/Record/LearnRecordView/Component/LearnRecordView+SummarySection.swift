//
//  LearnRecordView+SummarySection.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/08.
//

import SwiftUI

extension LearnRecordView {
    struct SummarySection: View {
        let title: String
        let wordCount: Int
        
        var body: some View {
            
            HStack {
                VStack {
                    Text(title)
                        .font(.system(size: responsiveSize(14, 18)))
                    Spacer()
                }
                
                Spacer()
                
                VStack {
                    Spacer()
                    Text("\(wordCount) 問")
                        .font(.system(size: responsiveSize(16, 20)))
                        .bold()
                }
            }
            .foregroundColor(.black.opacity(0.7))
            .padding(10)
            .background(.white)
            .cornerRadius(10)
            .padding(.horizontal, 40)
            .frame(height: responsiveSize(60, 80))
        }
    }
}
