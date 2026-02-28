import SwiftUI
import AudioToolbox

@MainActor
class Haptics {
    static let shared = Haptics()
    
    private let lightGenerator = UIImpactFeedbackGenerator(style: .light)
    private let mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let heavyGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private let softGenerator = UIImpactFeedbackGenerator(style: .soft)
    private let rigidGenerator = UIImpactFeedbackGenerator(style: .rigid)
    private let selectionGenerator = UISelectionFeedbackGenerator()
    private let notificationGenerator = UINotificationFeedbackGenerator()
    
    private init() {}
    
    func play(_ style: HapticStyle) {
        switch style {
        case .light:
            lightGenerator.impactOccurred()
        case .medium:
            mediumGenerator.impactOccurred()
        case .heavy:
            heavyGenerator.impactOccurred()
        case .soft:
            softGenerator.impactOccurred()
        case .rigid:
            rigidGenerator.impactOccurred()
        case .selection:
            selectionGenerator.selectionChanged()
        case .success:
            notificationGenerator.notificationOccurred(.success)
        case .warning:
            notificationGenerator.notificationOccurred(.warning)
        case .error:
            notificationGenerator.notificationOccurred(.error)
        }
    }
    
    func prepare(_ style: HapticStyle) {
        switch style {
        case .light: lightGenerator.prepare()
        case .medium: mediumGenerator.prepare()
        case .heavy: heavyGenerator.prepare()
        case .soft: softGenerator.prepare()
        case .rigid: rigidGenerator.prepare()
        case .selection: selectionGenerator.prepare()
        case .success, .warning, .error: notificationGenerator.prepare()
        }
    }
}

enum HapticStyle {
    case light, medium, heavy, soft, rigid
    case selection, success, warning, error
}

import AVFoundation

@MainActor
class SoundManager {
    static let shared = SoundManager()
    
    private let engine = AVAudioEngine()
    private let player = AVAudioPlayerNode()
    private let format: AVAudioFormat
    
    private init() {
        format = AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 1)!
        engine.attach(player)
        engine.connect(player, to: engine.mainMixerNode, format: format)
        do {
            try engine.start()
        } catch {
            print("Audio engine failed to start: \(error)")
        }
    }
    
    func playCorrect() {
        // A satisfying rising "pop" or "blip"
        playSynthesizedSound(frequencies: [600, 1200], duration: 0.15, volume: 0.3)
    }
    
    func playIncorrect() {
        // A muted, low declining "thump"
        playSynthesizedSound(frequencies: [300, 150], duration: 0.25, volume: 0.3)
    }
    
    func playLevelUp() {
        // A triumphant rapid ascending sweep
        playSynthesizedSound(frequencies: [440, 880, 1760], duration: 0.4, volume: 0.25)
    }
    
    func playNotification() {
        // A gentle double-tap beep
        playSynthesizedSound(frequencies: [800, 800], duration: 0.1, volume: 0.2)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.playSynthesizedSound(frequencies: [1200, 1200], duration: 0.15, volume: 0.2)
        }
    }
    
    private func playSynthesizedSound(frequencies: [Float], duration: Double, volume: Float) {
        guard engine.isRunning else {
            try? engine.start()
            if !engine.isRunning { return }
            return
        }
        
        let sampleRate = format.sampleRate
        let frameCount = AVAudioFrameCount(sampleRate * duration)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount),
              let channelData = buffer.floatChannelData?[0] else { return }
        
        buffer.frameLength = frameCount
        
        // Generate a smooth sweeping sine wave with an exponential decay envelope
        for i in 0..<Int(frameCount) {
            let t = Float(i) / Float(sampleRate)
            let progress = t / Float(duration)
            
            // Interpolate frequency across the array
            let freqIndex = progress * Float(frequencies.count - 1)
            let lowerIndex = min(Int(freqIndex), frequencies.count - 1)
            let upperIndex = min(lowerIndex + 1, frequencies.count - 1)
            let fraction = freqIndex - Float(lowerIndex)
            
            let f1 = frequencies[lowerIndex]
            let f2 = frequencies[upperIndex]
            let currentFreq = f1 + (f2 - f1) * fraction
            
            // Generate sine wave
            let wave = sin(2.0 * Float.pi * currentFreq * t)
            
            // Apply exponential decay envelope to avoid clicks and make it sound natural
            let envelope = pow(1.0 - progress, 2.0)
            
            channelData[i] = wave * envelope * volume
        }
        
        player.scheduleBuffer(buffer, at: nil, options: .interrupts)
        if !player.isPlaying {
            player.play()
        }
    }
}
