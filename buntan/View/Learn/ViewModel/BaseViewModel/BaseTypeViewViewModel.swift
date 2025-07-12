import SwiftUI


class BaseTypeViewViewModel: BaseLearnViewViewModel {
    
    /// keyboard 処理の正確性は保留中
    @Published var isKeyboardActive: Bool = false
    
    @Published var userInputAnswer: String = ""
    
    var isAnswering: Bool = true
    var isCorrect: Bool = true
    var hideSpealer: Bool { isAnswering || isCorrect }
}


extension BaseTypeViewViewModel {
    
    func onAppearAction() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isKeyboardActive = true
        }
    }
}


extension BaseTypeViewViewModel {
    
    /// return shouldSave: Bool
    internal func submitAction(shouldReadOut: Bool) async -> Bool {
        
        isAnswering = false
        
        if shouldReadOut {
            readOutTopCard(withDelay: true)
        }
        
        /// Removes only leading and trailing whitespace and newline characters from a string.
        let userAnswer = userInputAnswer.trimmingCharacters(in: .whitespacesAndNewlines)
        
        /// 正解時の処理
        if (userAnswer == topCard.word) || (userAnswer == topCard.clozeAnswer) {
            let shouldSave = await submitCorrectAnswerAction()
            return shouldSave
            
        /// 不正解時の処理
        } else {
            DispatchQueue.main.async {
                self.userInputAnswer = ""
                self.isCorrect = false
            }
            return false
        }
    }
    
    
    /// return shouldSave: Bool
    private func submitCorrectAnswerAction() async -> Bool {
        addIndexToList(isCorrect: true)
        
        DispatchQueue.main.async {
            self.isCorrect = true
        }

        guard nextCardExist else { return true }

        try? await Task.sleep(nanoseconds: 1_000_000_000)

        self.hideSettings()
        
        DispatchQueue.main.async {
            self.topCardIndex += 1
            self.userInputAnswer = ""
            self.isAnswering = true
            self.isKeyboardActive = true
        }

        return false
    }
}

extension BaseTypeViewViewModel {
    
    internal func passButtonAction(shouldReadOut: Bool) {
        
        isAnswering = false
        isCorrect = false
        userInputAnswer = ""
        
        if shouldReadOut {
            readOutTopCard(withDelay: true)
        }
    }
    
    internal func nextButtonAction() {
        hideSettings()
        addIndexToList(isCorrect: false)
        isAnswering = true
        
        ///  期待する通りに動作していない？ @2025/06/28
        isKeyboardActive = true
        
        topCardIndex += 1
        /// 不正解　→　正解　の場合の文字色変化を整えるため
        isCorrect = true
    }
    
    internal func typeViewBackButtonAction(backButtonAction: @escaping (() -> Void)) -> Void {
        
        userInputAnswer = ""
        
        ///　解答中　→　一つ前の問題の解答中画面へ
        if isAnswering {
            /// 一問目の場合を除く
            backButtonAction()
        } else {
            /// 解答後（かつ不正解）　→　同じ問題の解答中画面へ
            isAnswering = true
        }
        
        ///  期待する通りに動作していない？ @2025/06/28
        isKeyboardActive = true
    }
    
    internal func completeButtonAction(saveAction: @escaping () -> Void) -> Void {
        
        addIndexToList(isCorrect: false)
        isAnswering = true
        saveAction()
    }
}
