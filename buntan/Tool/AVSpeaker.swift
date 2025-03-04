import SwiftUI
import AVFoundation

class AVSpeaker {
 
    private let synthesizer = AVSpeechSynthesizer()

    @Binding var buttonDisabled: Bool

    init(_ buttonDisabled: Binding<Bool> = .constant(false)) {
        _buttonDisabled = buttonDisabled
    }
    
    func readOutText(_ text: String, controllButton: Bool, withDelay: Bool) -> Void {
        
        if controllButton { self.buttonDisabled = true }
        
        let utterance = AVSpeechUtterance(string: text)

        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.45
        utterance.pitchMultiplier = 1.5
        utterance.volume = 0.8
        utterance.postUtteranceDelay = withDelay ? 0.1 : 0.0

        synthesizer.speak(utterance)
        
        if controllButton {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.buttonDisabled = false
            }
        }
    }
}
