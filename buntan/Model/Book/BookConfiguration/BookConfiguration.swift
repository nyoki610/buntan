import Foundation


enum BookConfiguration: Hashable {
    case frequency(FrequencyBookConfiguration)
    case pos(PosBookConfiguration)

    var bookCategory: BookCategory {
        switch self {
        case .frequency(_): return .freq
        case .pos(_): return .pos
        }
    }
}

extension BookConfiguration: CaseIterable {
    static var allCases: [BookConfiguration] {
        return FrequencyBookConfiguration.allCases.map { .frequency($0) } +
               PosBookConfiguration.allCases.map { .pos($0) }
    }
}


extension BookConfiguration: BookConfigurationProtocol {
    
    var title: String {
        switch self {
        case .frequency(let config): return config.title
        case .pos(let config): return config.title
        }
    }
}
