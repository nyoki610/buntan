import SwiftUI

struct FlipWordCardView: ResponsiveView {
    
    enum ViewType {
        case swipe, select
    }
    
    @Environment(\.deviceType) var deviceType: DeviceType
    
    let viewType: ViewType
    let card: Card
    var showPhrase: Bool { viewType == .select }
    @Binding var isWordCardFlipped: Bool
    @Binding var isWordCardFlippedWithNoAnimation: Bool
    
    /// init for SwipeView
    init(
        card: Card,
        isWordCardFlipped: Binding<Bool>,
        isWordCardFlippedWithNoAnimation: Binding<Bool>
    ) {
        self.viewType = .swipe
        self.card = card
        self._isWordCardFlipped = isWordCardFlipped
        self._isWordCardFlippedWithNoAnimation = isWordCardFlippedWithNoAnimation
    }
    
    /// init for SelectView
    init(card: Card) {
        self.viewType = .select
        self.card = card
        self._isWordCardFlipped = .constant(false)
        self._isWordCardFlippedWithNoAnimation = .constant(false)
    }

    var body: some View {
        
        HStack {

            Spacer()
            
            VStack {
                
                Spacer()
                
                /// 表
                if !isWordCardFlippedWithNoAnimation {
                    VStack {
                     
                        Text(card.word)
                            .fontSize(responsiveSize(30, 40))
                            .fontWeight(.medium)
                            .lineLimit(1)
                        
                        if showPhrase && !card.phrase.isEmpty {
                            Text(card.phrase.parentheses())
                                .font(.system(size: responsiveSize(16, 24)))
                                .fontWeight(.medium)
                                .lineLimit(1)
                        }
                    }
                
                /// 裏
                } else {
                    
                    VStack {
                     
                        Text(card.posPrefix(card.meaning))
                            .font(.system(size: responsiveSize(20, 24)))
                            .fontWeight(.medium)
                            .lineLimit(2)
                            .padding(.bottom, 2)
                        
                        if !card.phrase.isEmpty {
                            
                            VStack {
                                Text("(\(card.phrase) で)")
                                    .font(.system(size: responsiveSize(14, 18)))
                                    .fontWeight(.medium)
                                    .lineLimit(2)
                            }
                        }
                    }
                    .rotation3DEffect(.degrees(-180), axis: (x: 0, y: 1, z: 0))
                }
                
                Spacer()
            }
            
            Spacer()
        }
        .background(.white)
        .frame(width: responsiveSize(280, 340), height: responsiveSize(100, 120))
        .cornerRadius(20)
        .shadow(radius: 5)
        .rotation3DEffect(
            .degrees(isWordCardFlipped ? -180 : 0),
            axis: (x: 0, y: 1, z: 0)
        )
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.4)) {
                isWordCardFlipped.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                isWordCardFlippedWithNoAnimation.toggle()
            }
        }
    }
}
