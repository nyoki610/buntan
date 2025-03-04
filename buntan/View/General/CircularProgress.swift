import SwiftUI

struct CircularProgress: View {
    
    @State var value: Int = 0
    let staticValue: Int
    let size: CGFloat
    let maxValue: Int
    let color: Color
    
    var circleWidth: CGFloat { 24 * size / 150 }
    
    init(staticValue: Int, size: CGFloat, maxValue: Int, color: Color) {
        self.staticValue = staticValue
        self.size = size
        self.maxValue = maxValue
        self.color = color
    }
    
    var body: some View {
        
        VStack {
            
            ZStack {
                /// background circle
                Circle()
                    .stroke(lineWidth: circleWidth)
                    .opacity(0.2)
                    .foregroundColor(color)

                /// circle which shows the progress
                Circle()
                    .trim(from: 0.0, to: min(CGFloat(value)/CGFloat(maxValue), 1.0))
                    .stroke(style: StrokeStyle(lineWidth: circleWidth, lineCap: .round, lineJoin: .round))
                    .foregroundColor(color)
                    .rotationEffect(Angle(degrees: 270.0))
                
                if maxValue == 100 {
                    Text(String(format: "%.0f%%", min(CGFloat(staticValue), 100.0)))
                        .font(.largeTitle)
                        .bold()
                } else {
                    HStack {
                        Text("\(staticValue)")
                            .font(.title)
                        Text(" / \(maxValue) 問")
                            .font(.title3)
                    }
                    .bold()
                }
            }
            .frame(width: size, height: size)
            .padding(.top, 30)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                self.value = staticValue
            }
        }
    }
}
