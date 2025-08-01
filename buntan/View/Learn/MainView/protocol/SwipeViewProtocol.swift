import SwiftUI


protocol SwipeViewProtocol: _LearnViewProtocol where
ViewModelType: BaseSwipeViewViewModel {}


extension SwipeViewProtocol {
    
    @ViewBuilder
    internal func cardView(
        isWordCardFlipped: Binding<Bool>,
        isWordCardFlippedWithNoAnimation: Binding<Bool>,
        isSentenceCardFlipped: Binding<Bool>,
        isSentenceCardFlippedWithNoAnimation: Binding<Bool>
    ) -> some View {
        
        if userDefaultHandler.showSentence {
            sentenceCardView(
                isSentenceCardFlipped: isSentenceCardFlipped,
                isSentenceCardFlippedWithNoAnimation: isSentenceCardFlippedWithNoAnimation
            )
            
            Spacer()
        }

        wordCardView(
            isWordCardFlipped: isWordCardFlipped,
            isWordCardFlippedWithNoAnimation: isWordCardFlippedWithNoAnimation
        )
    }
    
    @ViewBuilder
    private func sentenceCardView(
        isSentenceCardFlipped: Binding<Bool>,
        isSentenceCardFlippedWithNoAnimation: Binding<Bool>
    ) -> some View {
        
        VStack {
            
            FlipSentenceCardView(
                card: viewModel.nonAnimationCard,
                isSentenceCardFlipped: isSentenceCardFlipped,
                isSentenceCardFlippedWithNoAnimation: isSentenceCardFlippedWithNoAnimation
            )
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
    internal func wordCardView(
        isWordCardFlipped: Binding<Bool>,
        isWordCardFlippedWithNoAnimation: Binding<Bool>
    ) -> some View {
        
        VStack {
            
            /// 操作に関するガイド
            /// ------------------------------
            HStack(alignment: .bottom) {
                
                swipeGuide(
                    alignment: .leading,
                    label: "学習中",
                    systemName: "arrowshape.turn.up.left.fill",
                    color: RoyalBlue.defaultRoyal
                )
                
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
                
                swipeGuide(
                    alignment: .trailing,
                    label: "覚えた！",
                    systemName: "arrowshape.turn.up.right.fill",
                    color: Orange.defaultOrange
                )
            }
            .padding(.horizontal, responsiveSize(24, 72))
            .padding(.bottom, 20)
            .opacity(0.8)
            /// ------------------------------
            
            /// 単語カードを表示
            ZStack {
                ForEach(max(0, viewModel.topCardIndex - 1)..<min(viewModel.topCardIndex + 1, viewModel.cards.count), id: \.self) { index in

                    FlipWordCardView(
                        card: viewModel.cards[index],
                        isWordCardFlipped: isWordCardFlipped,
                        isWordCardFlippedWithNoAnimation: isWordCardFlippedWithNoAnimation
                    )
                    .offset(
                        x:  index == viewModel.topCardIndex ? viewModel.offset.width :
                            viewModel.rightCardsIndexList.contains(index) ? 600 :
                            viewModel.leftCardsIndexList.contains(index) ? -600 : 0
                    )
                    .rotationEffect(
                        .degrees(index == viewModel.topCardIndex ? Double(viewModel.offset.width / 300) * 15 : 0.0),
                        anchor: .bottom
                    )
                    .opacity(index == viewModel.topCardIndex ? 1.0 : 0.0)
                    .gesture(
                        drugGesture(index: index)
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
    
    private func drugGesture(index: Int) -> some Gesture {
        
        func dragGestureAction() {
            
            Task {
                let shouldSave = await viewModel.onEndedAction(
                    index: index,
                    animationDuration: responsiveSize(0.2, 0.4),
                    offsetAbs: responsiveSize(300, 600),
                    sholdReadOut: userDefaultHandler.shouldReadOut
                )
                
                if shouldSave {
                    /// animationの完了を待つ
                    try? await Task.sleep(nanoseconds: 0_300_000_000)
                    
                    saveAction()
                }
            }
        }
        
        return viewModel.dragGesture {
            dragGestureAction()
        }
    }
}
