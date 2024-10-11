import SwiftUI
import AVFoundation

struct FlashingView: View {
    @State private var isScreenPlaying = false
    @State private var isScreenFlickering = false
    @State private var screenFlashTimer: Timer?
    private let screenFlashRate: Double = 1.0 / 40.0
    
    var body: some View {
        ZStack {
            if isScreenPlaying {
                Color(isScreenFlickering ? .black : .white)
                    .edgesIgnoringSafeArea(.all)
                    .animation(.easeInOut(duration: screenFlashRate), value: isScreenFlickering)
            } else {
                Color(hex: "212121").edgesIgnoringSafeArea(.all)
            }

            VStack {
                Spacer()

                if !isScreenPlaying {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .padding()
                }

                Spacer()

                HStack {
                    FlashLightView()
                    AudioView()
                    CombinedView()

                    Button(action: {
                        isScreenPlaying.toggle()
                        toggleScreenFlickering()
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
        .onAppear {
            startFlickering()
        }
        .onDisappear {
            stopFlickering()
        }
    }


    private func startFlickering() {
        isScreenFlickering = true
        screenFlashTimer = Timer.scheduledTimer(withTimeInterval: screenFlashRate, repeats: true) { _ in
            isScreenFlickering.toggle()
        }
    }

    private func stopFlickering() {
        isScreenFlickering = false
        screenFlashTimer?.invalidate()
        screenFlashTimer = nil
    }

    private func toggleScreenFlickering() {
        if isScreenPlaying {
            startFlickering()
        } else {
            stopFlickering()
        }
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
