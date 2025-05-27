import SwiftUI

struct LearnSelectCircle: View {
    
    private let firstCircle: CircleInfo
    private let secondCircle: CircleInfo
    private let size: CGFloat
    private let maxValue: Int
    
    private var circleWidth: CGFloat { 24 * size / 150 }
    private var progressPercentage: CGFloat { CGFloat(secondCircle.value)/CGFloat(maxValue) * 100 }
    
    init(firstCircle: CircleInfo, secondCircle: CircleInfo, size: CGFloat, maxValue: Int) {
        self.firstCircle = firstCircle
        self.secondCircle = secondCircle
        self.size = size
        self.maxValue = maxValue
    }
    
    struct CircleInfo {
        let value: Int
        let color: Color
        
        func circle(maxValue: Int, circleWidth: CGFloat) -> some View {
            Circle()
                .trim(from: 0.0, to: min(CGFloat(value)/CGFloat(maxValue), 1.0))
                .stroke(style: StrokeStyle(lineWidth: circleWidth, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 270.0))
        }
    }
    
    var body: some View {
        
        ZStack {
            
            /// background circle
            Circle()
                .stroke(lineWidth: circleWidth)
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)

            /// circle which shows the progress
            firstCircle.circle(maxValue: maxValue, circleWidth: circleWidth)
            secondCircle.circle(maxValue: maxValue, circleWidth: circleWidth)

            Text(String(format: "%.0f%%", CGFloat(progressPercentage)))
                .font(.system(size: size * 0.2))
                .fontWeight(.bold)
        }
        .frame(width: size, height: size)
        .padding(.top, 30)
    }
}
