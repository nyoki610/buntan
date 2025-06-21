import Foundation


protocol BookConfigurationProtocol {
    
    var title: String { get }
    
    /// 不要?
    func filterCards(_ cards: [Card]) -> [Card]
}
