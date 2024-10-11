import SwiftUI
import AVFoundation

struct FlashingView: View {
    @State private var isFlashing = false
    @State private var isFlashingAndAudio = false
    @State private var isAudioPlaying = false
    @State private var isScreenPlaying = false
    @State private var flashTimer: Timer?
    @State private var audioPlayerNode: AVAudioPlayerNode?
    private let flashRate: Double = 1.0 / 40.0
    private var audioEngine = AVAudioEngine()
    let hapticManager = HapticManager()
    let fashLightManager = FlashLightManager()
    let audioManager = AudioManager()

    var body: some View {
            ZStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()

                VStack {
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            isFlashing.toggle()
                            if isFlashing {
                                startFlashing()
                                hapticManager.playHapticAt40Hz()
                            } else {
                                stopFlashing()
                                hapticManager.stopHaptic()
                            }
                        }) {
                            Image(systemName: isFlashing ? "lightbulb.fill" : "lightbulb")
                                .resizable()
                                .frame(width: 25, height: 32)
                                .foregroundColor(isFlashing ? .yellow : Color(hex: "f0f0f0"))
                                .padding()
                        }

                        Button(action: {
                            isAudioPlaying.toggle()
                            if isAudioPlaying {
                                play40HzSound()
                            } else {
                                stopSound()
                            }
                        }) {
                            Image(systemName: isAudioPlaying ? "speaker.fill" : "speaker.slash.fill")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .foregroundColor(isAudioPlaying ? .blue : Color(hex: "f0f0f0"))
                                .padding()
                        }
                        
                        Button(action: {
                            isFlashing.toggle()
                            isAudioPlaying.toggle()
                            isFlashingAndAudio.toggle()
                            if isFlashing {
                                startFlashing()
                                play40HzSound()
                            } else {
                                stopFlashing()
                                stopSound()
                            }
                        }) {
                            Image(isFlashingAndAudio ? "competence" : "competence-off")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .padding()
                        }
                        
                        Button(action: {
                            isScreenPlaying.toggle()
                        }) {
                            Image(isScreenPlaying ? "brightness" : "brightness-off")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .padding()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "2f2f2f"))
                    .cornerRadius(10)
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }


    private func startFlashing() {
        fashLightManager.startFlashing()
    }

    private func stopFlashing() {
        fashLightManager.stopFlashing()
    }

    private func stopSound() {
        audioManager.stopSound()
    }

    private func play40HzSound() {
        audioManager.playSound()
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            FlashingView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "212121"))
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ContentView()
}
