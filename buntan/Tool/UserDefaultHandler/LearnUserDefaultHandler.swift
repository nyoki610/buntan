import Foundation


class LearnUserDefaultHandler: ObservableObject {

    enum Key: String {
        case shouldShuffle
        case showSentence
        case shouldReadOut
        case showInitial
    }
    
    static let shared: LearnUserDefaultHandler = .init()
    
    @Published var shouldShuffle: Bool {
        didSet {
            UserDefaults.standard.set(shouldShuffle, forKey: Key.shouldShuffle.rawValue)
        }
    }
    @Published var showSentence: Bool {
        didSet {
            UserDefaults.standard.set(showSentence, forKey: Key.showSentence.rawValue)
        }
    }
    @Published var shouldReadOut: Bool {
        didSet {
            UserDefaults.standard.set(shouldReadOut, forKey: Key.shouldReadOut.rawValue)
        }
    }
    @Published var showInitial: Bool {
        didSet {
            UserDefaults.standard.set(showInitial, forKey: Key.showInitial.rawValue)
        }
    }
    
    private init() {

        func getBool(forKey key: Key) -> Bool? {
            UserDefaults.standard.object(forKey: key.rawValue) as? Bool
        }

        self.shouldShuffle = getBool(forKey: .shouldShuffle) ?? false
        self.showSentence = getBool(forKey: .showSentence) ?? true
        self.shouldReadOut = getBool(forKey: .shouldReadOut) ?? true
        self.showInitial = getBool(forKey: .showInitial) ?? true
    }
}
