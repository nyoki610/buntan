import SwiftUI

enum CustomColor {
    
    static let background: Color = Color(red: 0.9, green: 0.9, blue: 0.9, opacity: 0.3)
    static let headerGray: Color = Color(red: 0.7, green: 0.7, blue: 0.7, opacity: 0.7)
    
    static func convertRGB(_ red: Double, _ green: Double, _ blue: Double, _ opacity: Double = 1.0) -> Color {
        Color(red: red / 255, green: green / 255, blue: blue / 255, opacity: opacity)
    }
}

enum Orange {
    
    static let defaultOrange:Color = .orange
    static let translucent: Color = .orange.opacity(0.5)
    static let semiClear: Color = .orange.opacity(0.1)
    static let egg: Color = CustomColor.convertRGB(252, 212, 117) /// FFCE7B
}

enum RoyalBlue {
    
    static let defaultRoyal: Color = CustomColor.convertRGB(65, 105, 225)
    static let semiOpaque: Color = defaultRoyal.opacity(0.8)
    static let translucent: Color = defaultRoyal.opacity(0.5)
    static let semiClear: Color = defaultRoyal.opacity(0.1)
}
