import SwiftUI

class AlertSharedData: ObservableObject {

    /// alert 表示時に引数として受け取る
    @Published var alertType: AlertType?
    private var title: String = ""
    private var message: String = ""
    private var action: () -> Void = {}
    
    /// 省略可能な引数
    private var secondaryButtonLabel: String = ""
    private var secondaryButtonType: SecondaryButtonType = .defaultButton
    ///
    
    enum AlertType: Identifiable {
        
        var id: String { UUID().uuidString }
        
        case single
        case selective
    }
    
    enum SecondaryButtonType {
        case defaultButton
        case destructive
    }
    
    ///  just to be sure
    private func initializeProperties() -> Void {
        
        self.title = ""
        self.message = ""
        self.action = {}
        self.secondaryButtonType = .defaultButton
        self.secondaryButtonLabel = ""
    }
    
    private func showAlert(_ title: String,
                           _ message: String,
                           _ action: @escaping () -> Void,
                           _ alertType: AlertType,
                           _ seconddaryButtonLabel: String = "",
                           _ secondaryButtonType: SecondaryButtonType = .defaultButton) {
        
        DispatchQueue.main.async {
            self.title = title
            self.message = message
            self.action = action
            self.alertType = alertType
            self.secondaryButtonLabel = seconddaryButtonLabel
            self.secondaryButtonType = secondaryButtonType
        }
    }
    
    
    func showSingleAlert(_ title: String, _ message: String, _ action: @escaping () -> Void) {
        
        showAlert(title, message, action, .single)
    }
    
    func showSelectiveAlert(_ title: String, _ message: String, _ seconddaryButtonLabel: String, _ secondaryButtonType: SecondaryButtonType, _ action: @escaping () -> Void) {
        
        showAlert(title, message, action, .selective, seconddaryButtonLabel, secondaryButtonType)
    }
    
    
    func createAlert() -> Alert {
        
        switch self.alertType {
            
        case .single:
            return Alert(
                title: Text(title),
                message: Text(message),
                dismissButton: .default(Text("閉じる")) {
                    self.action()
                    self.initializeProperties()
                }
            )
            
        case .selective:
            let primaryButton = Alert.Button.default(Text("キャンセル")) {
                self.initializeProperties()
            }
            
            let secondaryButton = createSecondaryButton(secondaryButtonType)
            
            return Alert(
                title: Text(title),
                message: Text(message),
                primaryButton: primaryButton,
                secondaryButton: secondaryButton
            )
            
        default:
            return Alert(
                title: Text(""),
                message: Text(""),
                dismissButton: .default(Text("閉じる")) {
                    self.initializeProperties()
                }
            )
        }
        
        func createSecondaryButton(_ type: SecondaryButtonType) -> Alert.Button {
            
            switch type {
                
            case .defaultButton:
                return .default(Text(secondaryButtonLabel)) {
                    self.action()
                    self.initializeProperties()
                }
                
            case .destructive:
                return .destructive(Text(secondaryButtonLabel)) {
                    self.action()
                    self.initializeProperties()
                }
            }
        }
    }
    
    //static func processError(_ error: Error?, _ appError: AppError) -> AppError? {
    //    return (error == nil) ? nil : appError
    //}
       
    //func showError(_ error: AppError?, _ action: @escaping () -> Void) {
        
    //    let appError: AppError = error ?? .unexpectedError

    //    showSingleAlert(appError.errorTitle, appError.errorDescription) {
    //        action()
    //    }
    //}
}
