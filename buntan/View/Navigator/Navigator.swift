import Foundation

class Navigator<ViewName: ViewNameProtocol>: ObservableObject, Navigating {
    @Published var path: [ViewName] = []
}

final class BookNavigator: Navigator<BookViewName> {}
final class CheckNavigator: Navigator<CheckViewName> {}
