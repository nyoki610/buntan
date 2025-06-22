import SwiftUI
import RealmSwift

enum EikenGrade: Double, CaseIterable {
    
    case first = 1.0
    case preFirst = 1.5
    
    var index: Int {
        switch self {
        case .first: return 0
        case .preFirst: return 1
        }
    }
    
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
    
    var questionCount: Int {
        switch self {
        case .first: return 22
        case .preFirst: return 22
        }
    }
    
    var checkConfig: (Int, Int, Int) {
        
        func randomValue(_ value: Int) -> Int {
            let range = (max(0, value - 1))...(value + 1)
            return Int.random(in: range)
        }
        
        func getIntTupel(_ value1: Int, _ value2: Int) -> (Int, Int, Int) {
            let randamValue1 = randomValue(value1)
            let randamValue2 = randomValue(value2)
            let value3 = questionCount - randamValue1 - randamValue2
            return (randamValue1, randamValue2, value3)
        }
        
        switch self {
        case .first: return getIntTupel(9, 7)
        case .preFirst: return getIntTupel(0, 0)
        }
    }
}
