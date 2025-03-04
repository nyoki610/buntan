/*

import SwiftUI

extension LearnSelectView {
    
    @ViewBuilder
    func selectRangeButton(
        wordCount: Int,
        wordCountColor: Color,
        labelImage: String,
        labelText: String,
        targetRange: LearnRange
    ) -> some View {
        
        Button {
            bookSharedData.selectedRange = targetRange
        } label: {
            VStack {
                Text("\(wordCount)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(wordCountColor)
                Image(systemName: labelImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 30) 
                    .foregroundColor(.gray)
                Text(labelText)
                    .font(.system(size: 12))
            }
            .padding(5)
            .foregroundColor(.black)
            .frame(width: 80)
            .background(.white)
            .cornerRadius(10)
            .shadow(color: .gray, radius: 2, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Orange.defaultOrange
                            , lineWidth: bookSharedData.selectedRange == targetRange ? 2:0)
            )
        }
        .disabled(wordCount == 0)
    }
}
*/
