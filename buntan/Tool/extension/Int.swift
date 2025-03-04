import Foundation

extension Int {
    
    var string: String { String(self) }
    var nonZeroString: String { self == 0 ? "" : string }
    var double: Double { Double(self) }
}
