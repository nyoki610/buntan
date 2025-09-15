import SwiftUI

struct CheckView: View {


    @EnvironmentObject var loadingManager: LoadingManager
    
    @ObservedObject private var navigator: CheckNavigator
    @StateObject private var userInput = CheckUserInput()
    
    init(navigator: CheckNavigator) {
        self.navigator = navigator
    }
    
    var body: some View {
        
        NavigationStack(path: $navigator.path) {
            
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
            .navigationDestination(for: CheckViewName.self) { viewName in
                viewName.viewForName(navigator: navigator, userInput: userInput)
            }
            .onAppear {
                AnalyticsLogger.logScreenTransition(viewName: MainViewName.root(.check))
            }
        }
    }
    
    private func setupCheck() async {
        
        await loadingManager.startLoading(.process)
                
        guard let cards = SheetRealmAPI.getCaradsForCheck(eikenGrade: userInput.selectedGrade) else { return }
        
        guard let options = SheetRealmAPI.getOptions(
            eikenGrade: userInput.selectedGrade,
            cards: cards,
            containFifthOption: true
        ) else { return }

        await loadingManager.finishLoading()
        
        navigator.push(.checkSelect(cards, options))
    }
    
    @ViewBuilder
    private var topView: some View {
        
        VStack {
            
            HStack {
                
                if DeviceType.getDeviceType() == .iPad { Spacer() }
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
                if DeviceType.getDeviceType() == .iPad { Spacer() }
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
            
            Picker("grade", selection: $userInput.selectedGrade) {
                /// 要編集
                ForEach(EikenGrade.allCases, id: \.self) { grade in
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
        
        StartButton(label: "テストを開始　→",
                    color: Orange.defaultOrange) {
            Task { await setupCheck() }
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
                        
                        Image(systemName: "shoeprints.fill")
                            .font(.system(size: responsiveSize(18, 20)))
                            .foregroundColor(.gray)
                            
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
