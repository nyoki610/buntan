//
//  ChartRangePicker.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/09.
//

import SwiftUI

struct ChartRangePicker: View {
    enum ButtonType {
        case left
        case right
    }
    
    let label: String
    let rightButtonDisabled: Bool
    let leftButtonDisabled: Bool
    let action: (ButtonType) -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            ArrowButton(label: "←", buttonDisabled: leftButtonDisabled) {
                action(.left)
            }
            HStack(spacing: 0){
                Text(label)
            }
            .foregroundColor(.black.opacity(0.7))
            .frame(width: responsiveSize(140, 200))
            
            ArrowButton(label: "→", buttonDisabled: rightButtonDisabled) {
                action(.right)
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 10)
        .background(.white)
        .cornerRadius(20)
        .font(.system(size: responsiveSize(14, 20)))
        .bold()
    }
    
    struct ArrowButton: View {
        let label: String
        let buttonDisabled: Bool
        let action: () -> Void
        
        var body: some View {
            Button {
                action()
            } label: {
                Text(label)
            }
            .foregroundColor(.black)
            .padding(.vertical, 4)
            .padding(.horizontal, 20)
            .background(buttonDisabled ? .clear : Orange.translucent)
            .cornerRadius(20)
            .disabled(buttonDisabled)
        }
    }
}
