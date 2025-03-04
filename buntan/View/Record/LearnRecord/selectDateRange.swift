import SwiftUI

extension LearnRecordView {
    
    var yearString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: firstDate)
    }
    
    @ViewBuilder
    var selectDateRange: some View {
        
        VStack {
            
            Text(yearString)
                .foregroundColor(.black.opacity(0.7))
                .font(.system(size: responsiveSize(14, 20)))
                .bold()
            
            SelectRangeView(
                isLearnRecordView: true,
                rightButtonDisabled: firstDate >= Date().beforeSevenDays,
                leftButtonDisabled: firstDate <= lastDate,
                chartController: $chartController,
                startString: firstDate.monthDayString,
                endString: firstDate.afterSevenDays.monthDayString
            )
        }
    }
}
