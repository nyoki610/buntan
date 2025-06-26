import SwiftUI

struct BookSwipeViewl: ResponsiveView, BookLearnViewProtocol {
    
    @Environment(\.deviceType) var deviceType: DeviceType

    @EnvironmentObject var loadingSharedData: LoadingSharedData
    @EnvironmentObject var alertSharedData: AlertSharedData

    @StateObject var viewModel: BookSwipeViewViewModel
    @ObservedObject var userDefaultHandler: LearnUserDefaultHandler
    @ObservedObject var bookUserInput: BookUserInput
    @ObservedObject var pathHandler: PathHandler
    
    init(
        pathHandler: PathHandler,
        bookUserInput: BookUserInput,
        userDefaultHandler: LearnUserDefaultHandler,
        cards: [Card],
        options: [[Option]]
    ) {
        self.pathHandler = pathHandler
        self.bookUserInput = bookUserInput
        self.userDefaultHandler = userDefaultHandler
        self._viewModel = StateObject(
            wrappedValue: BookSwipeViewViewModel(
                cards: cards,
                options: options,
                shouldShuffle: userDefaultHandler.shouldShuffle
            )
        )
    }

    var body: some View {

        GeometryReader { geometry in
            
            VStack {

                learnHeader(geometry: geometry)

                Spacer()
                
                if userDefaultHandler.showSentence {
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
                viewModel.onAppearAction(shouldReadOut: userDefaultHandler.shouldReadOut)
            }
        }
    }
    
    @ViewBuilder
    private var sentenceCardView: some View {
        
        VStack {
            
            FlipSentenceCardView(card: viewModel.nonAnimationCard,
                                 isSelectView: false,
                                 isFlipped: $viewModel.isFlipped,
                                 isFlippedWithNoAnimation: $viewModel.isFlippedWithNoAnimation)
            .font(.system(size: 20))
            .opacity(viewModel.animationController == viewModel.cards.count ? 0.0 : 1.0)
            
            if viewModel.topCardIndex == 0 {
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
                
                if viewModel.topCardIndex == 0 {
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
                ForEach(max(0, viewModel.topCardIndex - 1)..<min(viewModel.topCardIndex + 1, viewModel.cards.count), id: \.self) { i in

                    FlipWordCardView(card: viewModel.cards[i],
                                     showPhrase: false)
                    .offset(x:  i == viewModel.topCardIndex ? viewModel.offset.width :
                                viewModel.rightCardsIndexList.contains(i) ? 600 :
                                viewModel.leftCardsIndexList.contains(i) ? -600 : 0)
                    .rotationEffect(
                        .degrees(i == viewModel.topCardIndex ? Double(viewModel.offset.width / 300) * 15 : 0.0),
                        anchor: .bottom
                    )
                    .opacity(i == viewModel.topCardIndex ? 1.0 : 0.0)
                    .gesture(
                        viewModel.dragGesture {
                            Task {
                                await viewModel.onEndedAction(
                                    index: i,
                                    animationDuration: responsiveSize(0.2, 0.4),
                                    offsetAbs: responsiveSize(300, 600),
                                    sholdReadOut: userDefaultHandler.shouldReadOut
                                )
                                
                                if !viewModel.nextCardExist {
                                    /// animationの完了を待つ
                                    try? await Task.sleep(nanoseconds: 0_300_000_000)
                                    
                                    saveAction()
                                }
                            }
                        }
                    )
                }
            }
            
            if viewModel.topCardIndex == 0 {
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
