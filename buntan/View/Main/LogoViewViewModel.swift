import SwiftUI
import Combine

@MainActor
class LogoViewViewModel: ObservableObject {

    private(set) var appVersionId: String?
    
    private let loadingManager: LoadingManager
    private let alertManager: AlertManager
    private var parentStateBinding: Binding<MainViewName>
    
    struct Dependency {
        let infoPlistRepository: any InfoPlistRepositoryProtocol = InfoPlistRepository()
        let openURLUseCase: any OpenURLUseCaseProtocol = OpenURLUseCase()
        let syncCardsUseCase: any SyncCardsUseCaseProtocol = SyncCardsUseCase()
        let checkForcedUpdateUseCase: any CheckForcedUpdateUseCaseProtocol = CheckForcedUpdateUseCase()
    }

    private let dependency: Dependency
    
    init(
        loadingManager: LoadingManager,
        alertManager: AlertManager,
        parentStateBinding: Binding<MainViewName>,
        dependency: Dependency = .init()
    ) {
        self.loadingManager = loadingManager
        self.alertManager = alertManager
        self.parentStateBinding = parentStateBinding
        self.dependency = dependency
    }
    
    internal func task() async {
        AnalyticsLogger.logScreenTransition(viewName: MainViewName.logo)
        appVersionId = dependency.infoPlistRepository.value(for: .appVersionId)
        let delay: UInt64 = 1_000_000_000
        try? await Task.sleep(nanoseconds: delay)
        
        await loadingManager.startLoading(.fetch)
        
        let requiredUpdateType = try? await dependency.checkForcedUpdateUseCase.isForcedUpdateRequired()
        switch requiredUpdateType {
        case .force:
            await loadingManager.finishLoading()
            self.parentStateBinding.wrappedValue = .forcedUpdate
        
        case .softForce:
            let config = AlertManager.SelectiveAlertConfig(
                title: "更新のお知らせ",
                message: "新しいバージョンが利用可能です。",
                secondaryButtonLabel: "アップデート",
                secondaryButtonType: .defaultButton,
                secondaryButtonAction: {
                    self.dependency.openURLUseCase.open(.appStore)
                    Task { await self.syncCards() }
                },
                closeButtonAction: { Task { await self.syncCards() } }
            )
            alertManager.showAlert(type: .selective(config: config))
        
        case .notRequired, nil:
            await syncCards()
        }
    }
    
    private func syncCards() async {
        let result = await dependency.syncCardsUseCase.execute(loadingManager: loadingManager)
        switch result {
        case .success(_):
            await complete()
        case let .failure(.general(detailedError, canSkip)):
            await handleError(canSkipDataFetching: canSkip, message: detailedError.localizedDescription)
        }
    }
    
    private func complete() async {
        await loadingManager.finishLoading(withDelay: true)
        parentStateBinding.wrappedValue = .root(.book)
    }
    
    private func handleError(canSkipDataFetching: Bool, message: String) async {
        let config: AlertManager.SingleAlertConfig = {
            if canSkipDataFetching {
                return .init(
                    title: nil,
                    message: "最新データの取得に失敗しました",
                    action: { Task { await self.complete() } }
                )
            } else {
                return .init(
                    title: nil,
                    message: "データの取得に失敗しました",
                    action: nil
                )
            }
        }()
        alertManager.showAlert(type: .single(config: config))
    }
}
