import SwiftUI

class BookSharedData: ObservableObject {

    var selectedGrade: EikenGrade = .first
    var selectedBookConfig: BookConfiguration = .frequency(.freqA)
    var selectedSectionTitle: String = ""
    var selectedBookCategory: BookCategory = .freq
    
    @Published var selectedMode: LearnMode = .swipe
    @Published var selectedRange: LearnRange = .notLearned

    var options: [[Option]] = []
}

