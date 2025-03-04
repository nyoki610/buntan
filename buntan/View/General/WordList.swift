import SwiftUI

struct WordList<Content: View>: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType: DeviceType
    
    @State var selectedCard: Card?
    let cards: [Card]
    let showInfo: Bool
    var correctIndexList: [Int]? = nil
    let content: () -> Content

    var body: some View {
        
        ZStack {
            
            VStack {
                
                content()
                
                Text("タップして例文を表示")
                    .fontSize(responsiveSize(16, 20))
                
                CustomScroll {
                    
                    ForEach(Array(cards.enumerated()), id: \.offset) { index, card in
                        VStack {
                            wordCardView(index, card)
                            if showInfo {
                                infoView(card.infoList)
                                    .padding(.bottom, 10)
                            }
                        }
                        .padding(.horizontal, responsiveSize(0, 40))
                    }
                }
                
                Spacer()
            }
            
            if let selectedCard = selectedCard {
                
                Background()
                    .onTapGesture {
                        self.selectedCard = nil
                    }
                
                VStack {
                    
                    Spacer()
                    
                    sentenceCardView(selectedCard)
                    
                    Text("画面をタップして閉じる")
                        .fontSize(responsiveSize(18, 24))
                        .fontWeight(.semibold)
                        .padding(.top, 10)
                    
                    Spacer()
                }
            }
        }
        .background(CustomColor.background)
        .navigationBarBackButtonHidden(true)
    }
    
    @ViewBuilder
    private func infoView(_ infoList: [Info]) -> some View {
        
        VStack {
         
            ForEach(Array(stride(from: 0, to: infoList.count, by: (deviceType == .iPhone) ? 3 : 5)), id: \.self) { index in
                HStack {

                    eachInfoView(infoList[index])
                        .padding(.leading, 20)
                    
                    if index + 1 < infoList.count {
                        eachInfoView(infoList[index+1])
                    }
                    
                    if index + 2 < infoList.count {
                        eachInfoView(infoList[index+2])
                    }
                    
                    if deviceType == .iPad {
                        if index + 3 < infoList.count {
                            eachInfoView(infoList[index+3])
                        }
                        if index + 4 < infoList.count {
                            eachInfoView(infoList[index+3])
                        }
                    }

                    Spacer()
                }
            }
        }
    }
    
    
    @ViewBuilder
    private func eachInfoView(_ info: Info) -> some View {
        
        HStack {
            Text("\(String(info.year)) 第\(info.time)回")
                .fontWeight(info.isAnswer ? .bold : .regular)
                .foregroundColor(info.isAnswer ? .black.opacity(0.6) : .gray)
            
            Img.img(info.isAnswer ? .circle : .xmark,
                       color: info.isAnswer ? Orange.defaultOrange : RoyalBlue.semiOpaque)
        }
        .frame(width: responsiveSize(110, 120))
        .fontSize(responsiveSize(12, 16))
    }
    
    @ViewBuilder
    private func wordCardView(_ index: Int, _ card: Card) -> some View {

        let isCorrect = correctIndexList?.contains(index) ?? true
        
        Button {
            selectedCard = card
        } label: {
            HStack {
                VStack {
                    if correctIndexList == nil {
                        Text((index + 1).string)
                    } else {
                        Img.img(isCorrect ? .circle : .xmark,
                                color: isCorrect ? Orange.defaultOrange : RoyalBlue.defaultRoyal)
                    }
                }
                .frame(width: 30)
                .font(.system(size: responsiveSize(14, 18)))

                HStack {
                    Text(card.wordWithPhrase)
                        .lineLimit(1)
                    Spacer()
                }
                .fontSize(responsiveSize(16, 20))
                .frame(width: responsiveSize(120, 180))

                Text(card.posPrefix(card.meaning))
                    .fontSize(responsiveSize(15, 19))
                    .lineLimit(1)
                
                Spacer()
            }
            .foregroundColor(.black)
            .padding(10)
            .background(isCorrect ? .white : RoyalBlue.semiClear)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.black.opacity(0.3), lineWidth: 1)
            )
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private func sentenceCardView(_ card: Card) -> some View {
        
        HStack {
            Spacer()
            
            VStack {
                
                Text(card.word)
                    .lineLimit(1)
                    .fontWeight(.semibold)
                    .fontSize(responsiveSize(18, 24))
                
                
                Text(card.customMeaning)
                    .lineLimit(1)
                    .fontSize(responsiveSize(15, 24))
                    .padding(.top, 4)
                
                
                if card.isSentenceExist {
                 
                    Text(CustomText.boldSentence(card: card, size: responsiveSize(16, 24), isUnderlined: false))
                        .fontSize(responsiveSize(16, 24))
                        .padding(.top, 10)
                    
                    Text(card.translation)
                        .fontSize(responsiveSize(15, 24))
                        .padding(.top, 4)
                } else {
                    
                    VStack {
                     
                        Text("この単語の例文は準備中です")
                            .fontSize(responsiveSize(16, 20))
                            .padding(.top, 10)
                            
                        Text("次回アップデートをお待ちください")
                            .fontSize(responsiveSize(14, 18))
                            .padding(.top, 4)
                    }
                    .foregroundColor(.gray)
                    .fontWeight(.medium)
                }
            }
            
            Spacer()
        }
        .padding(20)
        .background(.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.black.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }
}
