import SwiftUI
import Combine


class LogoViewViewModel: ObservableObject {
    
    @Published private(set) var loadingState: DataSyncState = .idle
    private var cancellables = Set<AnyCancellable>()
    
    internal enum DataSyncState {
        case idle
        case fetchingLatestVersionId
        case fetchingLatestCards(versionId: String)
        case completed
        case error(message: String)
    }
    
    private let loadingManager: LoadingManager
    private var parentStateBinding: Binding<MainViewName>
    
    init(loadingManager: LoadingManager, parentStateBinding: Binding<MainViewName>) {
        self.loadingManager = loadingManager
        self.parentStateBinding = parentStateBinding
        
        setupBindings()
    }
    
    private func setupBindings() {

        $loadingState
            .sink { [weak self] state in
                switch state {
                case .idle:
                    break
                case .fetchingLatestVersionId:
                    Task { @MainActor in
                        await self?.fetchLatestVersionId()
                    }
                case .fetchingLatestCards(let versionId):
                    Task { @MainActor in
                        await self?.fetchLatestCards(versionId: versionId)
                    }
                case .completed:
                    Task { @MainActor in
                        await self?.complete()
                    }
                case .error(_):
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    internal func task() async {
        
        AnalyticsLogger.logScreenTransition(viewName: MainViewName.logo)
        
        let delay: UInt64 = 1_000_000_000
        try? await Task.sleep(nanoseconds: delay)
        
        await loadingManager.startLoading(.fetch)
        await send(.fetchingLatestVersionId)
    }
    
    @MainActor
    private func send(_ state: DataSyncState) {
        loadingState = state
    }
    
    private func fetchLatestVersionId() async {
        
        do {
            let latestVersionId = try await APIHandler.getLatestVersion()
            let userCardsVersionId = VersionUserDefaultHandler.getUsersCardsVersionId() ?? ""
            let shouldFetchLatestCards = (latestVersionId != userCardsVersionId)
            
            if shouldFetchLatestCards {
                await loadingManager.startLoading(.custom(message: "更新中..."))
                await send(.fetchingLatestCards(versionId: latestVersionId))
            } else {
                let delay: UInt64 = 3_000_000_000
                try await Task.sleep(nanoseconds: delay)
                await send(.completed)
            }
        } catch {
            await send(.error(message: error.localizedDescription))
        }
    }
    
    private func fetchLatestCards(versionId: String) async {
        
        do {
            let (firstGradeCards, preFirstGradeCards) = try await APIHandler.getLatestCards()
            let _ = SheetRealmAPI.updateSheetCards(grade: .first, newCards: firstGradeCards)
            let _ = SheetRealmAPI.updateSheetCards(grade: .preFirst, newCards: preFirstGradeCards)
            let _ = SheetRealmAPI.deleteUnnecessaryObjects()
            
            VersionUserDefaultHandler.saveUsersCardsVersionId(version: versionId)
            await send(.completed)
        } catch {
            await send(.error(message: error.localizedDescription))
        }
    }
    
    @MainActor
    private func complete() async {
        await loadingManager.finishLoading(withDelay: true)
        withAnimation {
            parentStateBinding.wrappedValue = .root(.book)
        }
    }
}
