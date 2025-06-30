import SwiftUI

struct LearnRecordView: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType
    
    @State var chartController: Int = 0
    
    let dailyLearnRecords: [LearnRecord]
    
    init?() {
        
        guard let dailyLearnRecords: [LearnRecord] = LearnRecordRealmAPI.getDailyLearnRecords() else { return nil }
        self.dailyLearnRecords = dailyLearnRecords
    }

    var body: some View {
        
        VStack {
            
            selectDateRange
                .padding(.top, 20)
            
            ZStack {
                
                if maxCount == 0 {
                    
                    Text("この期間の記録はありません")
                        .bold()
                        .foregroundColor(.black.opacity(0.7))
                }
             
                chartView
                    .padding(20)
                    .frame(height: responsiveSize(340, 520))
            }
            .background(.white)
            .cornerRadius(10)
            .padding(.horizontal, 10)
            .padding(.top, 10)
            
            wordCountView
            
            Spacer()
        }
    }
}

extension LearnRecordView {
    
    @ViewBuilder
    private var wordCountView: some View {
        
        VStack {
            
            eachWordCount(.week)
            
            eachWordCount(.all)
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private func eachWordCount(_ wordCountRange: WordCountRange) -> some View {
        
        HStack {
            VStack {
                Text("\(wordCountRange.rawValue)に学習した問題数")
                    .font(.system(size: responsiveSize(14, 18)))
                Spacer()
            }
            
            Spacer()
            
            VStack {
                Spacer()
                Text("\(wordCount(wordCountRange)) 問")
                    .font(.system(size: responsiveSize(16, 20)))
                    .bold()
            }
        }
        .foregroundColor(.black.opacity(0.7))
        .padding(10)
        .background(.white)
        .cornerRadius(10)
        .frame(height: responsiveSize(60, 80))
        .padding(.horizontal, 20)
    }
    
    private enum WordCountRange: String {
        case week = "この週"
        case all = "これまで"
    }
    
    private func wordCount(_ wordCountRange: WordCountRange) -> Int {
        let calendar = Calendar.current
        
        switch wordCountRange {

        case .week:
            let targetWeek = calendar.dateComponents([.year, .weekOfYear], from: firstDate)
            return dailyLearnRecords
                .filter {
                    let recordWeek = calendar.dateComponents([.year, .weekOfYear], from: $0.date)
                    return recordWeek.year == targetWeek.year && recordWeek.weekOfYear == targetWeek.weekOfYear
                }
                .reduce(0) { $0 + $1.learnedCardCount }

        case .all:
            return dailyLearnRecords.reduce(0) { $0 + $1.learnedCardCount }
        }
    }
}
