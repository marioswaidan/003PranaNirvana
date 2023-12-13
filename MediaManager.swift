//
//  MediaManager.swift
//  Prana Sound Healing
//
//  Created by Mario Swaidan on 12/11/23.
//

import AVFoundation
import SwiftUI

class MediaManager: ObservableObject {
    enum SoundFile: String {
        case Root
    }
    var player: AVAudioPlayer?
    
    func playSound(for soundFile: SoundFile) {
        Task {
            guard let path = Bundle.main.path(forResource: soundFile.rawValue, ofType: "mp3") else {
                return}
            let url = URL(fileURLWithPath: path)
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, options: AVAudioSession.CategoryOptions.mixWithOthers)
                player = try AVAudioPlayer(contentsOf: url)
                player?.play()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    func pauseSound() {
        player!.pause()
    }
    func resumeSound() {
        player!.play()
    }
}
