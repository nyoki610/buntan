import Foundation

extension Array {
    func randomElements(_ n: Int) -> [Element] {
        guard n > 0, n <= count else { return [] }
        return Array(shuffled().prefix(n))
    }
}
