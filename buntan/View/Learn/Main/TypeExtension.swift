import SwiftUI

extension TypeView {
    
    func onAppearAction() {
        
        learnManager.avSpeaker = AVSpeaker()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            learnManager.isKeyboardActive = true
        }
    }
     
    func submitAction() -> Void {
        
        isAnswering = false
        
        learnManager.readOutTopCard()
        
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
        
        learnManager.addIndexToList(true)
        isCorrect = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            /// 最終以外の処理
            if nextCardExist {
                learnManager.hideSettings()
                learnManager.topCardIndex += 1
                userInputAnswer = ""
                isAnswering = true
                
                learnManager.isKeyboardActive = true
                
            } else {
                userInputAnswer = ""
                isAnswering = true
                saveAction(isBookView: true)
            }
        }
    }
    
    func passButtonAction() {
        
        isAnswering = false
        isCorrect = false
        userInputAnswer = ""
        learnManager.readOutTopCard()
    }
    
    func nextButtonAction() {
        learnManager.hideSettings()
        learnManager.addIndexToList(false)
        isAnswering = true
        learnManager.isKeyboardActive = true
        learnManager.topCardIndex += 1
        /// 不正解　→　正解　の場合の文字色変化を整えるため
        isCorrect = true
    }
    
    func backButtonAction() -> Void {
        
        userInputAnswer = ""
        
        ///　解答中　→　一つ前の問題の解答中画面へ
        if isAnswering {
            /// 一問目の場合を除く
            learnManager.backButtonAction()
        } else {
            /// 解答後（かつ不正解）　→　同じ問題の解答中画面へ
            isAnswering = true
        }
        
        learnManager.isKeyboardActive = true
    }
    
    func completeButtonAction() -> Void {
        
        learnManager.addIndexToList(false)
        isAnswering = true
        saveAction(isBookView: true)
    }
}
