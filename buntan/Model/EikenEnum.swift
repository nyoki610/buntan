import SwiftUI
import RealmSwift

enum EikenGrade: Double, CaseIterable, Hashable {
    
    case first = 1.0
    case preFirst = 1.5
    
    var title: String {
        switch self {
        case .first: return "1級"
        case .preFirst: return "準1級"
        }
    }
    
    var color: Color {
        switch self {
        case .first: return .green
        case .preFirst: return Color(red: 178 / 255, green: 210 / 255, blue: 53 / 255)
        }
    }
}
