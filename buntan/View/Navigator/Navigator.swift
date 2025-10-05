import Foundation

@MainActor
@Observable
class Navigator<ViewName: ViewNameProtocol>: Navigating {
    var path: [ViewName] = []
}

@MainActor
@Observable
final class BookNavigator: Navigator<BookViewName> {}

@MainActor
@Observable
final class CheckNavigator: Navigator<CheckViewName> {}
