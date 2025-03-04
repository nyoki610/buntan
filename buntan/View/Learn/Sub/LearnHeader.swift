import SwiftUI

struct LearnHeader: ResponsiveView, LearnViewProtocol {
    
    @Environment(\.deviceType) var deviceType: DeviceType
    
    @EnvironmentObject var realmService: RealmService
    @EnvironmentObject var loadingSharedData: LoadingSharedData
    @EnvironmentObject var alertSharedData: AlertSharedData
    
    @EnvironmentObject var bookSharedData: BookSharedData
    @EnvironmentObject var checkSharedData: CheckSharedData
    @EnvironmentObject var learnManager: LearnManager
    
    let geometry: GeometryProxy
    let learnMode: LearnMode?
    
    /// Shuffle前リストの保存用
    let cards: [Card]
    let options: [[Option]]?
    
    var isBookView: Bool { learnMode != nil }
    private var isTypeView: Bool { learnMode == .type }
    
    @State var sampleBool: Bool = false
    
    init(geometry: GeometryProxy,
         learnMode: LearnMode?,
         cards: [Card],
         options: [[Option]]?) {
        self.geometry = geometry
        self.learnMode = learnMode
        self.cards = cards
        
        /// CheckView の場合は不要
        self.options = options
    }
    
    var body: some View {
        
        VStack {
            
            ZStack {
                
                HStack {
                 
                    Button {
                        saveAction(isBookView: isBookView)
                    } label: {
                        Img.img(.xmark, size: responsiveSize(18, 24), color: .black)
                    }
                    
                    Spacer()
                    
                    Text("\(learnManager.rightCardsIndexList.count + learnManager.leftCardsIndexList.count) / \(learnManager.cards.count)")
                        .fontSize(responsiveSize(20, 28))
                        .foregroundColor(.black.opacity(0.8))
                        .bold()
                    
                    Spacer()
                    
                }
                .padding(.vertical, responsiveSize(20, 40))
                .padding(.horizontal, 30)
            }
            .background(.white)
            .overlay(
                learnProgressView,
                alignment: .bottom
            )
            
            HStack {
                if isBookView {
                    Spacer()
                    settingToggle(image: .shuffle,
                                  label: "シャッフル",
                                  subLabel: nil,
                                  targetBool: $learnManager.shouldShuffle) {
                        shuffleAction()
                    }
                }
                
                Spacer()
                settingToggle(image: .speakerWave2Fill,
                              label: "音声を",
                              subLabel: "自動再生",
                              targetBool: $learnManager.shouldReadOut)
                Spacer()

                if isBookView {
                    settingToggle(image: isTypeView ? .character : .textformatAbc,
                                  label: isTypeView ? "イニシャルを" : "例文を",
                                  subLabel: "表示",
                                  targetBool: isTypeView ? $learnManager.showInitial :  $learnManager.showSentence)
                    Spacer()
                }
            }
            .padding(.top, 10)
            
        }
    }
    
    @ViewBuilder
    private var learnProgressView: some View {
        
        let blueWidth = geometry.size.width *
        (learnManager.cards.count > 0 ? CGFloat(learnManager.leftCardsIndexList.count) / CGFloat(learnManager.cards.count) : 0)
        
        let pinkWidth = geometry.size.width *
        (learnManager.cards.count > 0 ? CGFloat(learnManager.rightCardsIndexList.count) / CGFloat(learnManager.cards.count) : 0)
        
        ZStack {
            
            Rectangle()
                .frame(height: 2.0)
                .foregroundColor(CustomColor.headerGray)
            
            HStack(spacing: 0) {
                Rectangle()
                    .frame(width: blueWidth, height: 5.0)
                    .cornerRadius(3)
                    .foregroundColor(RoyalBlue.defaultRoyal)

                
                Spacer()
                
                Rectangle()
                    .frame(width: pinkWidth,height: 5.0)
                    .cornerRadius(3)
                    .foregroundColor(Orange.defaultOrange)
            }
        }
    }
    
    @ViewBuilder
    private func settingToggle(image: Img, label: String, subLabel: String?, targetBool: Binding<Bool>, action: (() -> Void)? = nil) -> some View {
        HStack {
            CustomImage(image: image,
                        size: responsiveSize(18, 24),
                        color: targetBool.wrappedValue ? .black : .gray,
                        label: label,
                        subLabel: subLabel)
                .padding(.trailing, 4)
            
            CustomToggle(isOn: targetBool, color: Orange.egg, scale: responsiveSize(1.0, 1.3), action: action)
        }
        .offset(x: -5)
    }
    
    @ViewBuilder
    private func wordCount(label: String, count: Int, color: Color) -> some View {
        
        VStack {
            Text(label)
                .fontWeight(.medium)
            + Text("\(count)")
                .font(.system(size: 18))
                .bold()
        }
        .padding(.bottom, 10)
        .foregroundColor(color)
    }
}

extension LearnHeader {
    
    private func shuffleAction() -> Void {
        
        if learnManager.rightCardsIndexList.count + learnManager.leftCardsIndexList.count == 0 {
            
            learnManager.shouldShuffle.toggle()
            guard let options = options else { return }
            learnManager.setupLearn(cards, options)
        } else {
            confirmShuffle()
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
