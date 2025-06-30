import SwiftUI

extension MainView {
    
    /// アプリ起動時に表示されるタイトル画面
    var logoView: some View {
        
        VStack {
            
            Spacer()
            Spacer()
            Spacer()
            
            HStack(spacing: 0) {
                Spacer()
                VStack {
                    Spacer()
                    Text("ぶ")
                        .font(.system(size: responsiveScaled(48, 1.5)))
                        .fontWeight(.bold)
                        .foregroundColor(Orange.defaultOrange)
                    Spacer()
                }
                .frame(width: responsiveScaled(58, 1.5), height: responsiveScaled(58, 1.5))
                .background(.white)
                .clipShape(Circle())
                
                Text("んたん")
                    .font(.system(size: responsiveScaled(48, 1.5)))

                Spacer()
            }
            
            Text("for 英検®")
                .font(.system(size: responsiveScaled(30, 1.5)))
                .padding(.top, 8)
            
            Spacer()
            
            Text("例文で覚える英単語")
                .font(.system(size: responsiveScaled(30, 1.5)))
            
            Spacer()
            
            Text("ver 1.0.2")
                .font(.system(size: responsiveScaled(20, 1.5)))
                .fontWeight(.semibold)
            
            Spacer()
            Spacer()
            
            VStack {
                Text("英検®は、公益財団法人")
                Text("日本英語検定協会の登録商標です。")
                    .padding(.bottom, 10)
                Text("このコンテンツは、公益財団法人")
                Text("日本英語検定協会の承認や推奨、")
                Text("その他の検討を受けたものではありません。")
            }
            .font(.system(size: responsiveScaled(17, 1.5)))
            
            Spacer()
        }
        .foregroundColor(.white)
        .fontWeight(.bold)
        .frame(maxWidth: .infinity)
        .background(Orange.defaultOrange)
        .onAppear {
            AnalyticsHandler.logScreenTransition(viewName: ViewName.logo)
            
            let _ = SheetRealmAPI.deleteUnnecessaryObjects()
        }
    }
}
