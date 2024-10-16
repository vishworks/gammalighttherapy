//
//  AudioManager.swift
//  gammalighttherapy
//
//  Created by Tamilarasan on 11/10/24.
//

import SwiftUI
import AVFoundation

class AudioManager {
    @State private var audioPlayerNode: AVAudioPlayerNode?
    private var audioEngine = AVAudioEngine()
    
    
    private func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }

    func playSound() {
        configureAudioSession()

        let sampleRate = 44100.0
        let frequency = 40.0
        let amplitude = 1.0
        let duration = 1.0
        let frameCount = Int(sampleRate * duration)

        var soundData = [Float](repeating: 0, count: frameCount)

        for i in 0..<frameCount {
            let sampleTime = Double(i) / sampleRate
            let sineWave = sin(2.0 * .pi * frequency * sampleTime)
            soundData[i] = Float(sineWave) * Float(amplitude)
        }

        let audioFormat = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)
        let buffer = AVAudioPCMBuffer(pcmFormat: audioFormat!, frameCapacity: AVAudioFrameCount(frameCount))!
        buffer.frameLength = AVAudioFrameCount(frameCount)

        let channelData = buffer.floatChannelData![0]
        for i in 0..<frameCount {
            channelData[i] = soundData[i]
        }

        let playerNode = AVAudioPlayerNode()
        audioEngine.attach(playerNode)
        audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: buffer.format)

        do {
            try audioEngine.start()
            playerNode.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)
            playerNode.play()
            self.audioPlayerNode = playerNode
        } catch {
            print("Failed to start audio engine: \(error)")
        }
    }
    
    
    func stopSound() {
        audioPlayerNode?.stop()
        audioEngine.stop()
    }
    
}
