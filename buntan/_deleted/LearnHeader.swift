//import SwiftUI
//
//struct LearnHeader: ResponsiveView, LearnViewProtocol {
//    
//    @Environment(\.deviceType) var deviceType: DeviceType
//    
//    @EnvironmentObject var loadingSharedData: LoadingSharedData
//    @EnvironmentObject var alertSharedData: AlertSharedData
//
//    @EnvironmentObject var learnManager: LearnManager
//    
//    @ObservedObject var pathHandler: _PathHandler
//    @ObservedObject var userInput: UserInput
//    
//    let geometry: GeometryProxy
//    let learnMode: LearnMode?
//    
//    /// Shuffle前リストの保存用
//    let cards: [Card]
//    let options: [[Option]]?
//    
//    var isBookView: Bool { learnMode != nil }
//    private var isTypeView: Bool { learnMode == .type }
//    
//    init(pathHandler: _PathHandler,
//         userInput: UserInput,
//         geometry: GeometryProxy,
//         learnMode: LearnMode?,
//         cards: [Card],
//         options: [[Option]]?) {
//        self.pathHandler = pathHandler
//        self.userInput = userInput
//        self.geometry = geometry
//        self.learnMode = learnMode
//        self.cards = cards
//        
//        /// CheckView の場合は不要
//        self.options = options
//    }
//    
//    var body: some View {
//        
//        VStack {
//            
//            ZStack {
//                
//                HStack {
//                 
//                    Button {
//                        saveAction(isBookView: isBookView)
//                    } label: {
//                        Image(systemName: "xmark")
//                            .font(.system(size: responsiveSize(18, 24)))
//                            .foregroundColor(.black)
//                            .fontWeight(.bold)
//                    }
//                    
//                    Spacer()
//                    
//                    Text("\(learnManager.rightCardsIndexList.count + learnManager.leftCardsIndexList.count) / \(learnManager.cards.count)")
//                        .fontSize(responsiveSize(20, 28))
//                        .foregroundColor(.black.opacity(0.8))
//                        .bold()
//                    
//                    Spacer()
//                    
//                }
//                .padding(.vertical, responsiveSize(20, 40))
//                .padding(.horizontal, 30)
//            }
//            .background(.white)
//            .overlay(
//                learnProgressView,
//                alignment: .bottom
//            )
//            
//            if learnManager.showSettings {
//                
//                HStack {
//                    if isBookView {
//                        Spacer()
//                        settingToggle(label: "シャッフル",
//                                      subLabel: nil,
//                                      systemName: "shuffle",
//                                      targetBool: $learnManager.shouldShuffle) {
//                            shuffleAction()
//                        }
//                    }
//                    
//                    Spacer()
//                    settingToggle(label: "音声を",
//                                  subLabel: "自動再生",
//                                  systemName: "speaker.wave.2.fill",
//                                  targetBool: $learnManager.shouldReadOut)
//                    Spacer()
//
//                    if isBookView {
//                        settingToggle(label: isTypeView ? "イニシャルを" : "例文を",
//                                      subLabel: "表示",
//                                      systemName: isTypeView ? "character" : "textformat.abc",
//                                      targetBool: isTypeView ? $learnManager.showInitial :  $learnManager.showSentence)
//                        Spacer()
//                    }
//                }
//                .padding(.top, 10)
//            } else {
//                HStack {
//                    Spacer()
//                    Button {
//                        withAnimation(.easeOut(duration: 0.2)) {
//                            learnManager.showSettings = true
//                        }
//                    } label: {
//                        HStack {
//                            Image(systemName: "chevron.down")
//                            Text("設定を表示")
//                        }
//                        .font(.system(size: responsiveSize(16, 24)))
//                        .fontWeight(.bold)
//                        .foregroundStyle(.black.opacity(0.8))
//                    }
//                }
//                .padding(.top, 10)
//                .padding(.horizontal, responsiveSize(20, 40))
//            }
//            
//        }
//    }
//    
//    @ViewBuilder
//    private var learnProgressView: some View {
//        
//        let blueWidth = geometry.size.width *
//        (learnManager.cards.count > 0 ? CGFloat(learnManager.leftCardsIndexList.count) / CGFloat(learnManager.cards.count) : 0)
//        
//        let orangeWidth = geometry.size.width *
//        (learnManager.cards.count > 0 ? CGFloat(learnManager.rightCardsIndexList.count) / CGFloat(learnManager.cards.count) : 0)
//        
//        let progressRectangleHeight: CGFloat = 8.0
//        
//        ZStack {
//            
//            Rectangle()
//                .frame(height: 2.0)
//                .foregroundColor(CustomColor.headerGray)
//            
//            HStack(spacing: 0) {
//                Rectangle()
//                    .frame(width: blueWidth, height: progressRectangleHeight)
//                    .cornerRadius(3)
//                    .foregroundColor(RoyalBlue.defaultRoyal)
//
//                Spacer()
//                
//                Rectangle()
//                    .frame(width: orangeWidth, height: progressRectangleHeight)
//                    .cornerRadius(3)
//                    .foregroundColor(Orange.defaultOrange)
//            }
//        }
//    }
//
//    @ViewBuilder
//    private func settingToggle(
//        label: String,
//        subLabel: String?,
//        systemName: String,
//        targetBool: Binding<Bool>,
//        action: (() -> Void)? = nil
//    ) -> some View {
//        
//        let size = responsiveSize(20, 28)
//        let labelSize = size / 1.8
//        
//        HStack {
//            
//            VStack {
//
//                Image(systemName: systemName)
//                    .font(.system(size: size))
//                    
//                VStack {
//                    Text(label)
//                    if let subLabel = subLabel {
//                        Text(subLabel)
//                    }
//                }
//                .font(.system(size: labelSize))
//                .padding(.top, 4)
//            }
//            .foregroundStyle(.black)
//            .fontWeight(.bold)
//            .padding(.trailing, 4)
//            
//            CustomToggle(isOn: targetBool, color: Orange.egg, scale: responsiveSize(1.0, 1.3), action: action)
//        }
//        .offset(x: -5)
//    }
//    
//    @ViewBuilder
//    private func wordCount(label: String, count: Int, color: Color) -> some View {
//        
//        VStack {
//            Text(label)
//                .fontWeight(.medium)
//            + Text("\(count)")
//                .font(.system(size: 18))
//                .bold()
//        }
//        .padding(.bottom, 10)
//        .foregroundColor(color)
//    }
//}
//
//extension LearnHeader {
//    
//    private func shuffleAction() -> Void {
//        
//        if learnManager.rightCardsIndexList.count + learnManager.leftCardsIndexList.count == 0 {
//            
//            learnManager.shouldShuffle.toggle()
//            guard let options = options else { return }
//            learnManager.setupLearn(cards, options)
//        } else {
//            confirmShuffle()
//        }
//    }
//    
//    private func confirmShuffle() -> Void {
//        
//        var title = "現在の進捗はリセットされます\n"
//        title += learnManager.shouldShuffle ? "元に戻" : "シャッフル"
//        title += "しますか？"
//        
//        let secondaryButtonLabel = learnManager.shouldShuffle ? "元に戻す" : "シャッフル"
//        
//        alertSharedData.showSelectiveAlert(title: title,
//                                           message: "",
//                                           secondaryButtonLabel: secondaryButtonLabel,
//                                           secondaryButtonType: .defaultButton) {
//            learnManager.shouldShuffle.toggle()
//            guard let options = options else { return }
//            learnManager.setupLearn(cards, options)
//        }
//    }
//}
