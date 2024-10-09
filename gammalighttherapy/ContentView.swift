import SwiftUI
import AVFoundation

struct FlashingView: View {
    @State private var isFlashing = false
    @State private var flashTimer: Timer?
    @State private var audioPlayerNode: AVAudioPlayerNode?
    private let flashRate: Double = 1.0 / 40.0
    private var audioEngine = AVAudioEngine()

    var body: some View {
        VStack {
            Toggle("Enable Flashing", isOn: $isFlashing)
                .padding()
        }
        .onChange(of: isFlashing) { newValue in
            if newValue {
                startFlashing()
                play40HzSound()
            } else {
                stopFlashing()
                stopSound()
            }
        }
    }

    private func startFlashing() {
        flashTimer = Timer.scheduledTimer(withTimeInterval: flashRate, repeats: true) { _ in
            toggleTorch(on: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + self.flashRate) {
                self.toggleTorch(on: false)
            }
        }
    }

    private func stopFlashing() {
        toggleTorch(on: false)
        flashTimer?.invalidate()
        flashTimer = nil
    }

    private func stopSound() {
        audioPlayerNode?.stop()
        audioEngine.stop()
    }

    private func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            if on {
                try device.setTorchModeOn(level: 1.0)
            } else {
                device.torchMode = .off
            }
            device.unlockForConfiguration()
        } catch {
            print("Torch could not be used: \(error)")
        }
    }

    private func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }

    private func play40HzSound() {
        configureAudioSession()

        let sampleRate = 44100.0
        let frequency = 40.0
        let amplitude = 0.5
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
}

struct ContentView: View {
    var body: some View {
        FlashingView()
    }
}

#Preview {
    ContentView()
}
