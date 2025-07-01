import SwiftUI

struct FlipSentenceCardView: View {
    
    enum ViewType {
        case swipe, select
    }

    
    let viewType: ViewType
    let card: Card
    @Binding var isSentenceCardFlipped: Bool
    @Binding var isSentenceCardFlippedWithNoAnimation: Bool
    
    var isSelectView: Bool { viewType == .select }
    
    
    /// init for SwipeView
    init(
        card: Card,
        isSentenceCardFlipped: Binding<Bool>,
        isSentenceCardFlippedWithNoAnimation: Binding<Bool>
    ) {
        self.viewType = .swipe
        self.card = card
        self._isSentenceCardFlipped = isSentenceCardFlipped
        self._isSentenceCardFlippedWithNoAnimation = isSentenceCardFlippedWithNoAnimation
    }
    
    /// init for SelectView
    init(card: Card) {
        self.viewType = .select
        self.card = card
        self._isSentenceCardFlipped = .constant(false)
        self._isSentenceCardFlippedWithNoAnimation = .constant(false)
    }
    
    var body: some View {
        
        HStack {
            
            Spacer()

            VStack {
                
                Spacer()

                if !isSentenceCardFlippedWithNoAnimation {
                    
                    if card.isSentenceExist {
                        
                        let iPhoneFontSize: CGFloat = isSelectView ? 18 : 20
                        let iPadFontSize: CGFloat = 28
                        let size: CGFloat = responsiveSize(iPhoneFontSize, iPadFontSize)
                        
                        Text(
                            CustomText.boldSentence(
                                card: card,
                                size: size,
                                isUnderlined: true
                            )
                        )
                        .fontSize(size)
                    
                    /// 単語に例文が追加されていない場合
                    } else {
                        
                        VStack {
                         
                            Text("この単語の例文は準備中です")
                                .fontSize(responsiveSize(18, 24))
                                
                            Text("次回アップデートをお待ちください")
                                .fontSize(responsiveSize(16, 20))
                                .padding(.top, 4)
                        }
                        .foregroundColor(.gray)
                        .fontWeight(.medium)
                    }
                } else {
                    
                    if card.isSentenceExist {
                     
                        Text(card.translation)
                            .font(.system(size: responsiveSize(16, 24)))
                            .lineLimit(3)
                            .rotation3DEffect(.degrees(-180), axis: (x: 1, y: 0, z: 0))
                        
                        Spacer()
                    }
                    
                    Text(card.isSentenceExist ? CustomText.boldSentence(card: card, size: responsiveSize(16, 24), isUnderlined: true) : "例文は準備中です")
                        .fontSize(responsiveSize(16, 24))
                        .lineLimit(3)
                        .rotation3DEffect(.degrees(-180), axis: (x: 1, y: 0, z: 0))
                }
                
                Spacer()
            }
            .padding(5)
            
            Spacer()
        }
        .background(.white)
        .frame(width: responsiveSize(300, 500),
               height: responsiveSize(isSelectView ? 100 : 160, 180))
        .cornerRadius(5)
        .shadow(radius: 5)
        .rotation3DEffect(
            .degrees(isSentenceCardFlipped ? 180 : 0),
            axis: (x: 1, y: 0, z: 0)
        )
        .onTapGesture {
            // 例文が存在しない場合でもタップで反転できるようにする
            withAnimation(.easeInOut(duration: 0.4)) {
                isSentenceCardFlipped.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                isSentenceCardFlippedWithNoAnimation.toggle()
            }
        }
    }
}
