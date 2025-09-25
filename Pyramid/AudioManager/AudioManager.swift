import AVFoundation
import SwiftUI

class SoundManager: ObservableObject {
    static let shared = SoundManager()
    var bgPlayer: AVAudioPlayer?
    
    var wheelPlayer: AVAudioPlayer?
    
    var slot1: AVAudioPlayer?
    var slot2: AVAudioPlayer?
    var slot3: AVAudioPlayer?
    var slot4: AVAudioPlayer?
    
    @Published var backgroundVolume: Float = 1 {
        didSet {
            bgPlayer?.volume = backgroundVolume
        }
    }
    
    @Published var soundEffectVolume: Float = 1 {
        didSet {
            slot1?.volume = soundEffectVolume
            slot2?.volume = soundEffectVolume
            slot3?.volume = soundEffectVolume
            slot4?.volume = soundEffectVolume
        }
    }
    
    @Published var isSoundEnabled: Bool = true
    @Published var isMusicEnabled: Bool = true

    init() {
        loadBackgroundMusic()
        loadWheelMusic()
        loaSlot1Music()
        loaSlot2Music()
        loaSlot3Music()
        loaSlot4Music()

        if isMusicEnabled {
            playBackgroundMusic()
        }

        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    @objc private func appWillResignActive() {
        stopBackgroundMusic()
        stopWheelMusic()
        stopSlot1()
        stopSlot2()
        stopSlot3()
        stopSlot4()
    }

    @objc private func appDidBecomeActive() {
        if isMusicEnabled {
            playBackgroundMusic()
        }
    }

    private func loadBackgroundMusic() {
        if let url = Bundle.main.url(forResource: "bg", withExtension: "mp3") {
            do {
                bgPlayer = try AVAudioPlayer(contentsOf: url)
                bgPlayer?.numberOfLoops = -1
                bgPlayer?.volume = backgroundVolume
                bgPlayer?.prepareToPlay()
            } catch {
                print("Ошибка \(error)")
            }
        }
    }
    
    private func loadWheelMusic() {
        if let url = Bundle.main.url(forResource: "wheel", withExtension: "mp3") {
            do {
                wheelPlayer = try AVAudioPlayer(contentsOf: url)
                wheelPlayer?.volume = backgroundVolume
                wheelPlayer?.prepareToPlay()
            } catch {
                print("Ошибка \(error)")
            }
        }
    }
    
    func musicControl() {
        isMusicEnabled.toggle()
        if isMusicEnabled {
            playBackgroundMusic()
        } else {
            stopBackgroundMusic()
        }
    }
    
    private func loaSlot1Music() {
        if let url = Bundle.main.url(forResource: "slot1", withExtension: "mp3") {
            do {
                slot1 = try AVAudioPlayer(contentsOf: url)
                slot1?.volume = backgroundVolume
                slot1?.prepareToPlay()
            } catch {
                print("Ошибка \(error)")
            }
        }
    }
    
    private func loaSlot2Music() {
        if let url = Bundle.main.url(forResource: "slot2", withExtension: "mp3") {
            do {
                slot2 = try AVAudioPlayer(contentsOf: url)
                slot2?.volume = backgroundVolume
                slot2?.prepareToPlay()
            } catch {
                print("Ошибка \(error)")
            }
        }
    }
    
    private func loaSlot3Music() {
        if let url = Bundle.main.url(forResource: "slot3", withExtension: "mp3") {
            do {
                slot3 = try AVAudioPlayer(contentsOf: url)
                slot3?.volume = backgroundVolume
                slot3?.prepareToPlay()
            } catch {
                print("Ошибка \(error)")
            }
        }
    }
    
    private func loaSlot4Music() {
        if let url = Bundle.main.url(forResource: "slot4", withExtension: "mp3") {
            do {
                slot4 = try AVAudioPlayer(contentsOf: url)
                slot4?.volume = backgroundVolume
                slot4?.prepareToPlay()
            } catch {
                print("Ошибка \(error)")
            }
        }
    }
    
    func playBackgroundMusic() {
        if isMusicEnabled {
            bgPlayer?.play()
        }
    }
    
    func stopBackgroundMusic() {
        bgPlayer?.stop()
    }
    
    func playWheelMusic() {
        if isMusicEnabled {
            wheelPlayer?.play()
        }
    }
    
    func stopWheelMusic() {
        wheelPlayer?.stop()
    }
    
    func playSlot1() {
        if isMusicEnabled {
            slot1?.play()
        }
    }
    
    func stopSlot1() {
        slot1?.stop()
    }
    
    func playSlot2() {
        if isMusicEnabled {
            slot2?.play()
        }
    }
    
    func stopSlot2() {
        slot2?.stop()
    }
    
    func playSlot3() {
        if isMusicEnabled {
            slot3?.play()
        }
    }
    
    func stopSlot3() {
        slot3?.stop()
    }
    
    func playSlot4() {
        if isMusicEnabled {
            slot4?.play()
        }
    }
    
    func stopSlot4() {
        slot4?.stop()
    }
    
    func toggleSound() {
        isSoundEnabled.toggle()
    }
    
    func toggleMusic() {
        isMusicEnabled.toggle()
        if isMusicEnabled {
            playBackgroundMusic()
        } else {
            stopBackgroundMusic()
        }
    }
}
