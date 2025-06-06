import SwiftUI

struct SwipeView: ResponsiveView, LearnViewProtocol {
    
    @Environment(\.deviceType) var deviceType: DeviceType

    // Recordクラス内から直接保存できるように修正したい？
    @EnvironmentObject var realmService: RealmService
    @EnvironmentObject var loadingSharedData: LoadingSharedData
    @EnvironmentObject var alertSharedData: AlertSharedData
    
    @EnvironmentObject var bookSharedData: BookSharedData
    @EnvironmentObject var checkSharedData: CheckSharedData
    @EnvironmentObject var learnManager: LearnManager

    @State var offset = CGSize.zero
    @State var isFlipped: Bool = false
    @State var isFlippedWithNoAnimation: Bool = false

    private var animationController: Int { learnManager.animationController }
    private var nonAnimationCard: Card { animationController < cards.count ? cards[animationController] : EmptyModel.card }

    var body: some View {

        GeometryReader { geometry in
            
            VStack {
                
                LearnHeader(geometry: geometry,
                            learnMode: .swipe,
                            cards: bookSharedData.cards,
                            options: bookSharedData.options)
                Spacer()
                
                if learnManager.showSentence {
                    sentenceCardView
                    
                    Spacer()
                }

                wordCardView

                Spacer()
                
                LearnButton(learnMode: .swipe)
            }
            .background(CustomColor.background)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                onAppearAction()
            }
        }
    }
    
    @ViewBuilder
    private var sentenceCardView: some View {
        
        VStack {
            
            FlipSentenceCardView(card: nonAnimationCard,
                                 isSelectView: false,
                                 isFlipped: $isFlipped,
                                 isFlippedWithNoAnimation: $isFlippedWithNoAnimation)
            .font(.system(size: 20))
            .opacity(animationController == cards.count ? 0.0 : 1.0)
            
            if learnManager.showSettings {
                HStack {
                    Image(systemName: "hand.tap.fill")
                    Text("タップして訳を表示")
                }
                .padding(.top, 10)
                .fontWeight(.bold)
                .fontSize(responsiveSize(16, 24))
                .foregroundColor(.black.opacity(0.8))
            }
        }
    }
    
    @ViewBuilder
    private var wordCardView: some View {
        
        VStack {
            
            /// 操作に関するガイド
            /// ------------------------------
            HStack(alignment: .bottom) {
                
                swipeGuide(alignment: .leading,
                           label: "学習中",
                           systemName: "arrowshape.turn.up.left.fill",
                           color: RoyalBlue.defaultRoyal)
                
                Spacer()
                
                if learnManager.showSettings {
                    VStack {
                        Text("左右にスワイプして")
                        Text("次の単語へ")
                    }
                    .fontSize(responsiveSize(16, 24))
                    .fontWeight(.bold)
                    .foregroundColor(.black.opacity(0.8))
                }
                
                Spacer()
                
                swipeGuide(alignment: .trailing,
                           label: "覚えた！",
                           systemName: "arrowshape.turn.up.right.fill",
                           color: Orange.defaultOrange)
            }
            .padding(.horizontal, responsiveSize(24, 72))
            .padding(.bottom, 20)
            .opacity(0.8)
            /// ------------------------------
            
            /// 単語カードを表示
            ZStack {
                ForEach(max(0, topCardIndex - 1)..<min(topCardIndex + 1, cards.count), id: \.self) { i in

                    FlipWordCardView(card: cards[i],
                                     showPhrase: false)
                    .offset(x:  i == topCardIndex ? self.offset.width :
                                rightCardsIndexList.contains(i) ? 600 :
                                leftCardsIndexList.contains(i) ? -600 : 0)
                    .rotationEffect(.degrees(i == topCardIndex ? Double(self.offset.width / 300) * 15 : 0.0), anchor: .bottom)
                    .opacity(i == topCardIndex ? 1.0 : 0.0)
                    .gesture(dragGesture(for: i))
                }
            }
            
            if learnManager.showSettings {
                HStack {
                    Image(systemName: "hand.tap.fill")
                    Text("タップして意味を表示")
                }
                .padding(.top, 10)
                .fontWeight(.bold)
                .fontSize(responsiveSize(16, 24))
                .foregroundColor(.black.opacity(0.8))
            }
        }
    }
    
    @ViewBuilder
    private func swipeGuide(
        alignment: HorizontalAlignment,
        label: String,
        systemName: String,
        color: Color
    ) -> some View {
        
        VStack(alignment: alignment) {
            Text(label)
                .padding(.bottom, 4)
                .font(.system(size: responsiveSize(18, 28)))

            Image(systemName: systemName)
                .font(.system(size: responsiveSize(24, 28)))
        }
        .fontWeight(.bold)
        .foregroundStyle(color)
    }
}
