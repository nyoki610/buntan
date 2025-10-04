import SwiftUI

struct CheckRecordView: View {

    @State var chartController: Int = 0
    @State var selectedLearnMode: LearnMode = .swipe
    @State var selectedGrade: EikenGrade = .first
    
    @State var checkRecords: [CheckRecord] = []
    private let checkRecordUseCase: any CheckRecordServiceProtocol

    init(checkRecordUseCase: any CheckRecordServiceProtocol = CheckRecordUseCase()) {
        let appearance = UISegmentedControl.appearance()
        appearance.selectedSegmentTintColor = .init(Orange.translucent)

        self.checkRecordUseCase = checkRecordUseCase
    }
    
    var body: some View {
        
        VStack {
            
            Picker("grade", selection: $selectedGrade) {
                ForEach(EikenGrade.allCases, id: \.self) { grade in
                    Text(grade.title)
                        .fontSize(responsiveSize(16, 20))
                }
            }
                .background(Orange.semiClear.cornerRadius(10))
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
            .padding(.top, 32)
        }
        .task {
            if let checkRecords = try? checkRecordUseCase.getCheckRecords() {
                self.checkRecords = checkRecords
            }
        }
    }
}
