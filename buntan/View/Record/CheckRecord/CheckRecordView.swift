import SwiftUI

struct CheckRecordView: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType: DeviceType
    @EnvironmentObject var realmService: RealmService

    @State var chartController: Int = 0
    @State var selectedLearnMode: LearnMode = .swipe
    @State var selectedGrade: EikenGrade = .first

    init() {
        let appearance = UISegmentedControl.appearance()
        appearance.selectedSegmentTintColor = .init(Orange.translucent)
    }
    
    var body: some View {
        
        VStack {
            
            if !extractedRecords.isEmpty {
                
                let gradeList: Set<EikenGrade> = Set(realmService.checkRecords.map { $0.grade })
                let extractedGrades = EikenGrade.allCases.filter { gradeList.contains($0) }
                
                Picker("grade", selection: $selectedGrade) {
                    ForEach(extractedGrades, id: \.self) { grade in
                        Text(grade.title)
                            .fontSize(responsiveSize(16, 20))
                            .foregroundColor(.black)
                    }
                }
                .onChange(of: selectedGrade) { _ in
                    chartController = 0
                }
                .padding(.top, 4)
                
                

                SelectRangeView(
                    isLearnRecordView: false,
                    rightButtonDisabled: chartController <= 0,
                    leftButtonDisabled: prefixedRecords.count == 10
                        ? (chartController + 1) * 10 == extractedRecords.count
                        : prefixedRecords.count != 10,
                    chartController: $chartController,
                    startString: "",
                    endString: ""
                )
                .font(.system(size: 14))
                .foregroundColor(.black)
                .padding(.top, 10)
            }
            
            ZStack {
                
                if extractedRecords.isEmpty {
                    VStack {
                        Text("表示可能な記録がありません")
                    }
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
            .padding(.top, !extractedRecords.isEmpty ? 10 : 100)
        }
    }
}
