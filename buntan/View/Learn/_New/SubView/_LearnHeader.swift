import SwiftUI


struct _LearnHeader: ResponsiveView {
    
    @Environment(\.deviceType) internal var deviceType: DeviceType
    
    private let headerLabel: String
    
    private let blueBarWidth: CGFloat
    private let orangeBarWidth: CGFloat
    private let progressRectangleHeight: CGFloat = 8.0
    
    private let xmarkButtonAction: () -> Void
    
    init(
        viewModel: BaseLearnViewViewModel,
        geometry: GeometryProxy,
        xmarkButtonAction: @escaping () -> Void
    ) {
        
        self.headerLabel = "\(viewModel.rightCardsIndexList.count + viewModel.leftCardsIndexList.count) / \(viewModel.cards.count)"
        
        self.blueBarWidth = geometry.size.width *
        (viewModel.cards.count > 0 ? CGFloat(viewModel.leftCardsIndexList.count) / CGFloat(viewModel.cards.count) : 0)
        
        self.orangeBarWidth = geometry.size.width *
        (viewModel.cards.count > 0 ? CGFloat(viewModel.rightCardsIndexList.count) / CGFloat(viewModel.cards.count) : 0)
        
        self.xmarkButtonAction = xmarkButtonAction
    }
    
    var body: some View {
        
        HStack {
         
            Button {
                xmarkButtonAction()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: responsiveSize(18, 24)))
                    .foregroundColor(.black)
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            Text(headerLabel)
                .fontSize(responsiveSize(20, 28))
                .foregroundColor(.black.opacity(0.8))
                .bold()
            
            Spacer()
            
        }
        .padding(.vertical, responsiveSize(20, 40))
        .padding(.horizontal, 30)
        .background(.white)
        .overlay(
            learnProgressView,
            alignment: .bottom
        )
    }
    
    @ViewBuilder
    private var learnProgressView: some View {
        
        ZStack {
            
            Rectangle()
                .frame(height: 2.0)
                .foregroundColor(CustomColor.headerGray)
            
            HStack(spacing: 0) {
                Rectangle()
                    .frame(width: blueBarWidth, height: progressRectangleHeight)
                    .cornerRadius(3)
                    .foregroundColor(RoyalBlue.defaultRoyal)

                Spacer()
                
                Rectangle()
                    .frame(width: orangeBarWidth, height: progressRectangleHeight)
                    .cornerRadius(3)
                    .foregroundColor(Orange.defaultOrange)
            }
        }
    }
}
