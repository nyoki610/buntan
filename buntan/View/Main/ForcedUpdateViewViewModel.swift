//
//  ForcedUpdateViewViewModel.swift
//  buntan
//
//  Created by 二木裕也 on 2025/09/21.
//

import SwiftUI

class ForcedUpdateViewViewModel: ObservableObject {
    
    private let alertManager: AlertManager
    let alertMessage = "アプリを引き続きご利用いただくためには\nアップデートが必要です。"
    
    init(alertManager: AlertManager) {
        self.alertManager = alertManager
    }
    
    @MainActor
    func task() {
        AnalyticsLogger.logScreenTransition(viewName: MainViewName.forcedUpdate)
        
        let config = AlertManager.SingleAlertConfig(
            title: "更新のお知らせ",
            message: alertMessage
        ) {}
        alertManager.showAlert(type: .single(config: config))
    }
    
    func openAppStore() {
        let contactFormURL = "https://x.gd/R38a3"
        guard let url = URL(string: contactFormURL) else { return }
        UIApplication.shared.open(url)
    }
}
