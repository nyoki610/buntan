import SwiftUI

struct CheckView: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType: DeviceType
    
    @EnvironmentObject var realmService: RealmService
    @EnvironmentObject var loadingSharedData: LoadingSharedData
    @EnvironmentObject var checkSharedData: CheckSharedData
    @EnvironmentObject var learnManager: LearnManager
    
    var body: some View {
        
        NavigationStack(path: $checkSharedData.path) {
            
            VStack {
                
                Spacer()
                Spacer()
                
                topView

                Spacer()
                
                buttonView

                Spacer()
                
                bottomView
                
                Spacer()
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(CustomColor.background)
            .navigationDestination(for: ViewName.self) { viewName in
                viewName.viewForName(viewName)
            }
        }
    }
    
    private func setupCheck() {
        
        loadingSharedData.startLoading(.process)
        
        checkSharedData.extractCards()
        
        guard
            !checkSharedData.cards.isEmpty,
            let options = checkSharedData.selectedGrade.setupOptions(booksList: checkSharedData.booksList,
                                                                     cards: checkSharedData.cards,
                                                                     isBookView: false) else { loadingSharedData.finishLoading {}; return }

        learnManager.setupLearn(checkSharedData.cards, options)
        
        loadingSharedData.finishLoading {
            checkSharedData.path.append(LearnMode.select.viewName(isBookView: false))
        }
    }
    
    @ViewBuilder
    private var topView: some View {
        
        VStack {
            
            HStack {
                
                if deviceType == .iPad { Spacer() }
                Spacer()
                
                VStack {
                    Text("各級の英単語")
                    Text("カバー率")
                }
                .fontSize(responsiveSize(16, 20))
                .fontWeight(.bold)
                .background(
                    Circle()
                        .fill(Orange.translucent)
                        .frame(width: responsiveSize(120, 180), height: responsiveSize(120, 180))
                )
                
                Spacer()
                
                Text("&")
                    .font(.system(size: responsiveSize(20, 30)))
                    .fontWeight(.bold)
                
                Spacer()
                
                VStack {
                    Text("語彙問題の")
                    Text("予想得点")
                }
                .fontSize(responsiveSize(16, 20))
                .fontWeight(.bold)
                .background(
                    Circle()
                        .fill(Orange.egg)
                        .frame(width: responsiveSize(120, 180), height: responsiveSize(120, 180))
                )
                
                Spacer()
                if deviceType == .iPad { Spacer() }
            }
            
            Text("がわかる！")
                .font(.system(size: responsiveSize(16, 20)))
                .fontWeight(.bold)
                .padding(.top, 60)
                .padding(.leading, 10)
        }
    }
    
    @ViewBuilder
    private var buttonView: some View {
        
        HStack {
            
            Spacer()
            Spacer()
            
            Text("級を選択：")
                .fontWeight(.bold)
            
            Spacer()
            
            Picker("grade", selection: $checkSharedData.selectedGrade) {
                ForEach(Eiken.allCases.filter { realmService.convertGradeToSheet($0) != nil }, id: \.self) { grade in
                    Text(grade.title)
                        .bold()
                }
            }
            .fontSize(responsiveSize(16, 20))
            .background(Orange.semiClear.cornerRadius(10))
            
            Spacer()
            Spacer()
        }
        .padding(.bottom, 20)
        .font(.system(size: responsiveSize(16, 20)))
        
        TLButton(title: "テストを開始　→",
                 textColor: .white,
                 background: Orange.defaultOrange) {
            setupCheck()
        }
    }
    
    @ViewBuilder
    private var bottomView: some View {
        
        VStack {
            
            HStack {
                Spacer()
                Text("過去のテストの記録は")
                VStack {
                    
                    ZStack {
                        
                        Circle()
                            .foregroundColor(.gray.opacity(0.1))
                            .frame(height: 40)
                        
                        Img.img(.shoeprintsFill,
                                size: responsiveSize(18, 20),
                                color: .gray)
                    }

                    Text("記録")
                        .padding(.top, 4)
                }
                Text("から確認できます。")
                Spacer()
            }
            .font(.system(size: responsiveSize(12, 20)))
            .foregroundColor(.gray)
            .fontWeight(.bold)
            .padding(.bottom, 20)
            
            VStack {
                Text("カバー率・予想得点は独自の方法で算出しています。")
                Text("学習の目安として活用してください。")
            }
            .font(.system(size: responsiveSize(12, 20)))
            .fontWeight(.medium)
            .padding(.horizontal, 30)
            .foregroundColor(.gray)
        }
    }
}
