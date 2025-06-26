import SwiftUI

struct FlipWordCardView: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType: DeviceType
    
    @State private var isFlipped = false
    @State private var isFlippedWithNoAnimation = false

    let card: Card
    let showPhrase: Bool

    var body: some View {
        
        HStack {

            Spacer()
            
            VStack {
                
                Spacer()
                if !isFlippedWithNoAnimation {
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
            .degrees(isFlipped ? -180 : 0),
            axis: (x: 0, y: 1, z: 0)
        )
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.4)) {
                isFlipped.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                isFlippedWithNoAnimation.toggle()
            }
        }
    }
}
