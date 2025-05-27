import SwiftUI

struct WordListView: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType: DeviceType
    
    @EnvironmentObject var realmService: RealmService
    @EnvironmentObject var bookSharedData: BookSharedData
    
    @State var showInfo: Bool = true

    var body: some View {
        
        WordList(cards: bookSharedData.cardsContainer[LearnRange.all.rawValue],
                 showInfo: showInfo) {
            
            VStack {
             
                Header(path: $bookSharedData.path,
                       title: "単語一覧")
                
                HStack {
                    Spacer()
                    Text("過去の出題情報を表示")
                        .foregroundColor(.black.opacity(0.8))
                        .font(.system(size: responsiveSize(14, 20)))
                        .fontWeight(.medium)
                    CustomToggle(isOn: $showInfo, color: Orange.defaultOrange, scale: responsiveSize(1.0, 1.3), action: nil)
                        .padding(.trailing, responsiveSize(0, 40))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                if showInfo {
                    HStack {
                        Spacer()
                        Text("正解として出題・・・")

                        Image(systemName: "circle")
                            .foregroundStyle(Orange.defaultOrange)
                            .font(.system(size: 17))
                            .fontWeight(.bold)
                            
                        Spacer()
                        Text("選択肢として出題・・・")

                        Image(systemName: "xmark")
                            .foregroundStyle(RoyalBlue.defaultRoyal)
                            .font(.system(size: 17))
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                    .font(.system(size: responsiveSize(13, 20)))
                    .padding(.bottom, 20)
                }
            }
        }
        .background(CustomColor.background)
        .navigationBarBackButtonHidden(true)
    }
}
