import Foundation


class LearnUserDefaultHandler: ObservableObject {
    
    @Published var shouldShuffle: Bool
    @Published var showSentence: Bool
    @Published var shouldReadOut: Bool
    @Published var showInitial: Bool
    
    init() {
        self.shouldShuffle = UserDefaults.standard.object(forKey: "shouldShuffle") as? Bool ?? true
        self.showSentence = UserDefaults.standard.object(forKey: "showSentence") as? Bool ?? true
        self.shouldReadOut = UserDefaults.standard.object(forKey: "shouldReadOut") as? Bool ?? true
        self.showInitial = UserDefaults.standard.object(forKey: "showInitial") as? Bool ?? false
    }

    func save() {
        UserDefaults.standard.set(shouldShuffle, forKey: "shouldShuffle")
        UserDefaults.standard.set(showSentence, forKey: "showSentence")
        UserDefaults.standard.set(shouldReadOut, forKey: "shouldReadOut")
        UserDefaults.standard.set(showInitial, forKey: "showInitial")
    }
}
