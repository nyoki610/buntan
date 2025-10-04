//
//  AlertManager.swift
//  buntan
//
//  Created by 二木裕也 on 2025/10/05.
//

import SwiftUI

@MainActor
class AlertManager: ObservableObject {
    
    @Published var alertType: AlertType?
    
    enum AlertType: Identifiable {
        case single(config: SingleAlertConfig)
        case selective(config: SelectiveAlertConfig)
        
        var id: String { UUID().uuidString }
    }
    
    struct SingleAlertConfig {
        let title: String
        let message: String
        let action: () -> Void
        
        init(title: String?, message: String?, action: (() -> Void)?) {
            self.title = title ?? ""
            self.message = message ?? ""
            self.action = action ?? {}
        }
    }
    
    struct SelectiveAlertConfig {
        let title: String
        let message: String
        let secondaryButtonLabel: String
        let secondaryButtonType: SecondaryButtonType
        let secondaryButtonAction: () -> Void
        let closeButtonAction: () -> Void
        
        enum SecondaryButtonType {
            case defaultButton
            case destructive
        }
        
        init(title: String?, message: String?, secondaryButtonLabel: String, secondaryButtonType: SecondaryButtonType, secondaryButtonAction: (() -> Void)?, closeButtonAction: (() -> Void)? = nil) {
            self.title = title ?? ""
            self.message = message ?? ""
            self.secondaryButtonLabel = secondaryButtonLabel
            self.secondaryButtonType = secondaryButtonType
            self.secondaryButtonAction = secondaryButtonAction ?? {}
            self.closeButtonAction = closeButtonAction ?? {}
        }
    }
    
    func showAlert(type: AlertType) {
        alertType = type
        return
    }
    
    func createAlert() -> Alert {
        
        switch self.alertType {
            
        case let .single(config):
            return Alert(
                title: Text(config.title),
                message: Text(config.message),
                dismissButton: .default(Text("閉じる")) {
                    config.action()
                }
            )
            
        case let .selective(config):
            let primaryButton = Alert.Button.default(Text("キャンセル")) {
                config.closeButtonAction()
            }
            let secondaryButton = createSecondaryButton(config)
            
            return Alert(
                title: Text(config.title),
                message: Text(config.message),
                primaryButton: primaryButton,
                secondaryButton: secondaryButton
            )
            
        default:
            return Alert(
                title: Text(""),
                message: Text(""),
                dismissButton: .default(Text("閉じる"))
            )
        }
    }
    
    private func createSecondaryButton(_ config: SelectiveAlertConfig) -> Alert.Button {
        
        switch config.secondaryButtonType {
            
        case .defaultButton:
            return .default(Text(config.secondaryButtonLabel)) {
                config.secondaryButtonAction()
            }
            
        case .destructive:
            return .destructive(Text(config.secondaryButtonLabel)) {
                config.secondaryButtonAction()
            }
        }
    }
}
