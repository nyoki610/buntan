import SwiftUI

struct SelectRangeView: View {

    let isLearnRecordView: Bool
    let rightButtonDisabled: Bool
    let leftButtonDisabled: Bool
    
    @Binding var chartController: Int
    
    let startString: String
    let endString: String
    
    init(isLearnRecordView: Bool,
         rightButtonDisabled: Bool,
         leftButtonDisabled: Bool,
         chartController: Binding<Int>,
         startString: String,
         endString: String) {
        self.isLearnRecordView = isLearnRecordView
        self.rightButtonDisabled = rightButtonDisabled
        self.leftButtonDisabled = leftButtonDisabled
        _chartController = chartController
        self.startString = startString
        self.endString = endString
    }
    
    var body: some View {
        
        HStack {
            arrowButton(false)
            
            HStack{
                
                if isLearnRecordView {
                    adjustedData(startString)
                    Spacer()
                    Text("〜")
                    Spacer()
                    adjustedData(endString)
                } else {
                    Text(chartController == 0 ? "直近の記録" : "過去の記録")
                }
            }
            .foregroundColor(.black.opacity(0.7))
            .frame(width: responsiveSize(140, 200))
            .padding(.horizontal, 24)
            
            arrowButton(true)
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 10)
        .background(.white)
        .cornerRadius(20)
        .font(.system(size: responsiveSize(14, 20)))
        .bold()
    }
    
    @ViewBuilder
    private func adjustedData(_ dateString: String) -> some View {
        
        HStack {
            Text(dateString)
        }
        .frame(width: responsiveSize(50, 72))
    }
    
    @ViewBuilder
    private func arrowButton(_ isRightButton: Bool) -> some View {
        
        let buttonDisabled = (isRightButton && rightButtonDisabled) || (!isRightButton && leftButtonDisabled)
        
        Button {
            chartController += isRightButton ? -1 : 1
        } label: {
            Text(isRightButton ? "→" : "←")
        }
        .foregroundColor(.black)
        .padding(.vertical, 4)
        .padding(.horizontal, 20)
        .background(buttonDisabled ? .clear : Orange.translucent)
        .cornerRadius(20)
        .disabled(buttonDisabled)
    }
}
