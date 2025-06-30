import SwiftUI
import AVFoundation

class AVSpeaker {
 
    private let synthesizer = AVSpeechSynthesizer()

    func readOutText(text: String, withDelay: Bool) -> Void {
        
        let utterance = AVSpeechUtterance(string: text)

        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.45
        utterance.pitchMultiplier = 1.5
        utterance.volume = 0.8
        utterance.postUtteranceDelay = withDelay ? 0.1 : 0.0

        synthesizer.speak(utterance)
    }
}
