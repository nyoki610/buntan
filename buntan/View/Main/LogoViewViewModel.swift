import SwiftUI
import Combine


class LogoViewViewModel: ObservableObject {
    
    @Published private(set) var loadingState: DataSyncState = .idle
    let appVersionId: String? = InfoPlistRepository.value(for: .appVersionId)
    private var cancellables = Set<AnyCancellable>()
    private var canSkipDataFetching: Bool = false
    
    internal enum DataSyncState {
        case idle
        case fetchingLatestVersionId
        case fetchingLatestCards(versionId: String)
        case completed
        case error(message: String?)
    }
    
    private let loadingManager: LoadingManager
    private let alertManager: AlertManager
    private var parentStateBinding: Binding<MainViewName>
    
    init(loadingManager: LoadingManager, alertManager: AlertManager, parentStateBinding: Binding<MainViewName>) {
        self.loadingManager = loadingManager
        self.alertManager = alertManager
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
                case let .error(message):
                    Task { @MainActor in
                        await self?.handleError(message: message)
                    }
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
            let userDBVersionId = VersionUserDefaultHandler.getValue(forKey: .usersCardsVersionId)
            
            if userDBVersionId != nil {
                canSkipDataFetching = true
            }
            
            guard let latestDBVersionId = try await RemoteConfigService.shared.string(.latestDBVersionId) else {
                await send(.error(message: nil))
                return
            }

            /// This property is unused in version 1.1.1
            guard let requiredAppVersionId = try await RemoteConfigService.shared.string(.requiredAppVersionId) else {
                await send(.error(message: nil))
                return
            }
            
            let shouldFetchLatestCards = (latestDBVersionId != userDBVersionId)
            
            if shouldFetchLatestCards {
                await loadingManager.startLoading(.custom(message: "更新中..."))
                await send(.fetchingLatestCards(versionId: latestDBVersionId))
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
            let response = try await BuntanClient.getCardsLatest(config: AppConfig.shared)
            let _ = SheetRealmAPI.updateSheetCards(grade: .first, newCards: response.firstGradeCards)
            let _ = SheetRealmAPI.updateSheetCards(grade: .preFirst, newCards: response.preFirstGradeCards)
            let _ = SheetRealmAPI.deleteUnnecessaryObjects()
            VersionUserDefaultHandler.setValue(value: versionId, forKey: .usersCardsVersionId)
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
    
    private func handleError(message: String?) async {
        
        if canSkipDataFetching {
            
            let config = AlertManager.SingleAlertConfig(
                title: nil,
                message: "最新データの取得に失敗しました"
            ) {
                Task { await self.send(.completed) }
            }
            await alertManager.showAlert(type: .single(config: config))
            return
        }

        #if DEBUG
        if let message = message {
            print(message)
        }
        #endif
        
        let config = AlertManager.SingleAlertConfig(
            title: nil,
            message: "データの取得に失敗しました",
            action: nil
        )
        await alertManager.showAlert(type: .single(config: config))
        return
    }
}
