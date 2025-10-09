import SwiftUI

extension RecordView {
    
    var selectViewType: some View {
        
        HStack {
            
            selectButton(.learn)
            selectButton(.check)
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 4)
        .background(.white)
        .cornerRadius(10)
    }
    
    @ViewBuilder
    private func selectButton(_ viewType: CheckViewType) -> some View {
        
        let isSelected = self.viewType == viewType
        
        Button {
            self.viewType = viewType
        } label:{
            VStack {
                Text(viewType.rawValue)
                    .font(.system(size: responsiveSize(16, 20)))
                    .bold()
            }
            .frame(width: responsiveSize(160, 200))
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .foregroundColor(isSelected ? .black : .gray)
            .background(isSelected ? Orange.translucent : .clear)
            .cornerRadius(10)
        }
    }
    
    enum CheckViewType: String {
        case learn = "学習の記録"
        case check = "テストの記録"
    }
}
