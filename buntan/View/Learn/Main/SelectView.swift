import SwiftUI

struct SelectView: ResponsiveView, LearnViewProtocol {
    
    @Environment(\.deviceType) var deviceType: DeviceType
    
    @EnvironmentObject var realmService: RealmService
    @EnvironmentObject var loadingSharedData: LoadingSharedData
    @EnvironmentObject var alertSharedData: AlertSharedData
    
    @EnvironmentObject var bookSharedData: BookSharedData
    @EnvironmentObject var checkSharedData: CheckSharedData
    @EnvironmentObject var learnManager: LearnManager
    
    let isBookView: Bool

    init(_ isBookView: Bool) {
        self.isBookView = isBookView
    }
    
    @State var isAnswering: Bool = true
    @State var selectedIndex: Int = 0
    private var answerIndex: Int { learnManager.options[topCardIndex].firstIndex { topCard.word == $0.word } ?? 0 }
    var isCorrect: Bool { selectedIndex == answerIndex}
    
    var body: some View {

        GeometryReader { geometry in
            
            VStack {
                
                LearnHeader(geometry: geometry,
                            learnMode: isBookView ? .select : nil,
                            cards: isBookView ? bookSharedData.cards : checkSharedData.cards,
                            options: isBookView ? bookSharedData.options : nil)
                
                Spacer()
                
                if learnManager.showSentence && isBookView {
                    
                    FlipSentenceCardView(card: topCard,
                                         isSelectView: true)
                } else {
                 
                    FlipWordCardView(card: topCard,
                                     showPhrase: true)
                    .disabled(true)
                }
                
                Spacer()
                
                ForEach(0...(isBookView ? 3 : 4), id: \.self) { i in
                    optionView(i)
                        .disabled(!isAnswering)
                        .padding(.bottom, 10)
                }
                
                Spacer()
                
                LearnButton(learnMode: isBookView ? .select : nil) {
                    Task { await buttonAction(-1) }
                }
                .disabled(!isAnswering)
            }
            .background(CustomColor.background)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                onAppearAction()
            }
        }
    }
    
    @ViewBuilder
    private func optionView(_ index: Int) -> some View {
        
        Button {
            
            Task { await buttonAction(index) }
            
        } label: {
            
            HStack {
                
                Spacer()
                
                ZStack {
                    
                    VStack {
                        
                        Spacer()
                        
                        let buttonLabel = (index != 4) ? learnManager.options[topCardIndex][index].meaning : "正解なし"

                        Text(buttonLabel)
                            .foregroundColor(.black)
                            .font(.system(size: responsiveSize(20, 28)))
                            .lineLimit(1)
                        
                        Spacer()
                    }
                    
                    if !isAnswering && index == selectedIndex {
                        
                        HStack {
                            
                            Img.img(isCorrect ? .circle : .xmark,
                                    size: (index != 4) ? responsiveSize(30, 40) : 24,
                                    color: isCorrect ? Orange.defaultOrange : RoyalBlue.defaultRoyal)
                            .padding(.leading, responsiveSize(6, 12))
                            
                            Spacer()
                        }
                    }
                }
                
                Spacer()
            }
            .background(.white)
            .frame(width: (index != 4) ? responsiveSize(280, 340) : responsiveSize(160, 180),
                   height: (index != 4) ? responsiveSize(60, 80) : responsiveSize(40, 48))
            .overlay(
                buttonOverlay(index)
              )
            .cornerRadius(40)
            .shadow(radius: 2)
        }
    }
    
    @ViewBuilder
    private func buttonOverlay(_ index: Int) -> some View {
        
        let isCorrect = index == answerIndex
        let isActive = !isAnswering && (isCorrect || index == selectedIndex)
        let backgroundColor = isCorrect ? Orange.semiClear : RoyalBlue.semiClear
        let borderColor = isCorrect ? Orange.translucent : RoyalBlue.translucent

        if isActive {
            ZStack {
                backgroundColor
                RoundedRectangle(cornerRadius: 40)
                    .stroke(borderColor, lineWidth: 4)
            }
        }
    }
}
