import SwiftUI


class BaseTypeViewViewModel: BaseLearnViewViewModel {
    
    var isKeyboardActive: Bool = false
    @Published var userInputAnswer: String = ""
    
    var isAnswering: Bool = true
    var isCorrect: Bool = true
    var showSpeaker: Bool { !(isAnswering && isCorrect) }
}


extension BaseTypeViewViewModel {
    
    func onAppearAction() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isKeyboardActive = true
        }
    }
}


extension BaseTypeViewViewModel {
    
    func submitAction(shouldReadOut: Bool) -> Void {
        
        isAnswering = false
        
        readOutTopCard(
            isButton: false,
            shouldReadOut: shouldReadOut
        )
        
        let userAnswer = userInputAnswer.filter { !$0.isWhitespace }
        
        /// 正解時の処理
        if userAnswer == topCard.answer {
            submitCorrectAnswerAction()
            
            /// 不正解時の処理
        } else {
            userInputAnswer = ""
            isCorrect = false
        }
    }
    
    private func submitCorrectAnswerAction() -> Void {
        
        addIndexToList(true)
        isCorrect = true
        
        guard nextCardExist else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            self.hideSettings()
            self.topCardIndex += 1
            self.userInputAnswer = ""
            self.isAnswering = true
            
            self.isKeyboardActive = true
        }
    }
}

extension BaseTypeViewViewModel {
    
    func passButtonAction(shouldReadOut: Bool) {
        
        isAnswering = false
        isCorrect = false
        userInputAnswer = ""
        readOutTopCard(isButton: false, shouldReadOut: shouldReadOut)
    }
    
    func nextButtonAction() {
        hideSettings()
        addIndexToList(false)
        isAnswering = true
        isKeyboardActive = true
        topCardIndex += 1
        /// 不正解　→　正解　の場合の文字色変化を整えるため
        isCorrect = true
    }
    
    func typeViewBackButtonAction(backButtonAction: @escaping (() -> Void)) -> Void {
        
        userInputAnswer = ""
        
        ///　解答中　→　一つ前の問題の解答中画面へ
        if isAnswering {
            /// 一問目の場合を除く
            backButtonAction()
        } else {
            /// 解答後（かつ不正解）　→　同じ問題の解答中画面へ
            isAnswering = true
        }
        
        isKeyboardActive = true
    }
    
    func completeButtonAction(saveAction: @escaping () -> Void) -> Void {
        
        addIndexToList(false)
        isAnswering = true
        saveAction()
    }
}
