import SwiftUI

struct FlipSentenceCardView: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType: DeviceType
    
    let card: Card
    let isSelectView: Bool
    @Binding var isFlipped: Bool
    
    init(card: Card, isSelectView: Bool, isFlipped: Binding<Bool> = .constant(false)) {
        self.card = card
        self.isSelectView = isSelectView
        self._isFlipped = isFlipped
    }

    var body: some View {
        
        HStack {
            
            Spacer()

            VStack {
                
                Spacer()

                if !isFlipped {
                    
                    if card.isSentenceExist {
                        
                        let iPhoneFontSize: CGFloat = isSelectView ? 18 : 20
                        let iPadFontSize: CGFloat = 28
                        let size: CGFloat = responsiveSize(iPhoneFontSize, iPadFontSize)
                        
                        Text(CustomText.boldSentence(card: card,
                                                     size: size,
                                                     isUnderlined: true))
                        .fontSize(size)
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
            .degrees(isFlipped ? 180 : 0),
            axis: (x: 1, y: 0, z: 0)
        )
        .onTapGesture {
            guard card.isSentenceExist else { return }
            withAnimation {
                isFlipped.toggle()
            }
        }
    }
}
