/*
 import SwiftUI

 struct LearnSetting: View {

     @EnvironmentObject var alertSharedData: AlertSharedData
     @EnvironmentObject var learnManager: LearnManager
     
     @Binding var isSetting: Bool
     
     let viewType: ViewType
     enum ViewType {
         case swipe
         case type
     }
     
     let isBookView: Bool
     
     /// Shuffle前リストの保存用
     let cards: [Card]
     let options: [[Option]]?

     init(viewType: ViewType,
          isBookView: Bool,
          isSetting: Binding<Bool>,
          cards: [Card],
          options: [[Option]]?) {
         
         self.viewType = viewType
         self.isBookView = isBookView
         _isSetting = isSetting
         self.cards = cards
         
         /// CheckView の場合は不要
         self.options = options
     }
     
     var body: some View {
         
         ZStack {
             
             if isSetting {
                 
                 Background()
                     .onTapGesture {
                         isSetting = false
                     }
             }
             
             VStack {
                 
                 HStack {
                     
                     Spacer()
                     
                     mainView
                 }
                 
                 Spacer()
             }
         }
     }
     
     @ViewBuilder
     private var mainView: some View {
         
         VStack(alignment: .trailing) {
             
             if !isSetting {
                 
                 Button {
                     withAnimation(.linear(duration: 0.2)) {
                         isSetting = true
                     }
                 } label: {
                     VStack {
                         Img.img(.gearshapeFill,
                                 color: .black)
                         Text("設定")
                             .font(.system(size: 12))
                     }
                     .frame(width: 44, height: 40)
                     .foregroundColor(.black)
                     .bold()
                 }
                 
             } else {
                 
                 settingView
             }
         }
         .padding()
     }
     
     @ViewBuilder
     private var settingView: some View {
         
         VStack(alignment: .trailing) {
             
             if isBookView {
                 
                 buttonView(buttonLabel: "シャッフル",
                            image: .shuffle,
                            targetBool: learnManager.shouldShuffle) {
                     shuffleAction()
                 }
                            .padding(.top, 10)
             }
                 
             if viewType == .type {
                 
                 buttonView(buttonLabel: "イニシャル表示",
                            image: .character,
                            targetBool: learnManager.showInitial,
                            action: {
                     learnManager.showInitial.toggle()
                 })
                 .padding(.top, 10)
             }
             
             buttonView(buttonLabel: "自動音声再生",
                        image: learnManager.shouldReadOut ? .speakerWave2Fill : .speakerSlash,
                        targetBool: learnManager.shouldReadOut) {
                 learnManager.shouldReadOut.toggle()
             }
                        .padding(.top, 10)
         }
         .padding(.top, 50)
     }
     
     @ViewBuilder
     private func buttonView(buttonLabel: String, image: Img, targetBool: Bool, action: @escaping () -> Void) -> some View {
         
         HStack {
             Text(buttonLabel)
                 .padding(.trailing)
                 .bold()
                 .foregroundColor(.white)
             
             Button {
                 action()
             } label: {
                 VStack {
                     Image(systemName: image.rawValue)
                         .resizable()
                         .frame(width: 20, height: 20)
                     Text(targetBool ? "オン" : "オフ")
                         .font(.system(size: 12))
                         .bold()
                 }
                 .foregroundColor(targetBool ? Color(red: 1.0, green: 0.6, blue: 0.0, opacity: 1.0) : .black)
             }
             .frame(width: 60, height: 60)
             .background(Color.white)
             .foregroundColor(.black)
             .clipShape(Circle())
             .transition(.move(edge: .top))
         }
     }
     
     private func shuffleAction() -> Void {
         
         if learnManager.rightCardsIndexList.count + learnManager.leftCardsIndexList.count != 0 {
             confirmShuffle()
         } else {
             learnManager.shouldShuffle.toggle()
             
             guard let options = options else { return }
             learnManager.setupLearn(cards, options)
         }
     }
     
     private func confirmShuffle() -> Void {
         
         var title = "現在の進捗はリセットされます\n"
         title += learnManager.shouldShuffle ? "元に戻" : "シャッフル"
         title += "しますか？"
         
         let secondaryButtonLabel = learnManager.shouldShuffle ? "元に戻す" : "シャッフル"
         
         alertSharedData.showSelectiveAlert(title, "", secondaryButtonLabel, .defaultButton) {
             learnManager.shouldShuffle.toggle()
             
             guard let options = options else { return }
             learnManager.setupLearn(cards, options)
         }
     }
 }

 */
