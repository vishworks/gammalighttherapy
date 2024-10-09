//
//  ContentView.swift
//  gammalighttherapy
//
//  Created by Tamilarasan on 30/09/24.
//

import SwiftUI
import AVFoundation

struct FlashingScreenView: View {
    @State private var isVisible = true
    private let flashRate: Double = 1.0 / 40.0
    
    var body: some View {
        ZStack {
            if isVisible {
                Color.white // Example: Red color that flashes
            } else {
                Color.black // Example: Black color that alternates with red
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            startFlashing()
        }
    }
    
    // Function to start the flashing effect
    private func startFlashing() {
        Timer.scheduledTimer(withTimeInterval: flashRate, repeats: true) { timer in
            isVisible.toggle()  // Toggle visibility to create flashing effect
        }
    }
}

struct FlashingView: View {
    @State private var isFlashing = false
    private let flashRate: Double = 1.0 / 40.0
    var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        VStack {
            Toggle("Enable Flashing", isOn: $isFlashing)
                .padding()
        }
        .onChange(of: isFlashing) { newValue in
            if newValue {
                startFlashing()
            } else {
                stopFlashing()
            }
        }
    }
    
    // Start the flashlight flashing effect
    private func startFlashing() {
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async {
            while isFlashing {
                toggleTorch(on: true)
                usleep(UInt32(flashRate * 1_000_000)) // 25ms delay
                toggleTorch(on: false)
                usleep(UInt32(flashRate * 1_000_000)) // 25ms delay
            }
        }
    }
    
    // Stop the flashing
    private func stopFlashing() {
        toggleTorch(on: false) // Ensure the torch is off when stopping
    }
    

       func stopSound() {
           audioPlayer?.stop()
       }

    // Helper function to control the flashlight (torch)
    private func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            if on {
                try device.setTorchModeOn(level: 1.0) // Set torch on at max brightness
            } else {
                device.torchMode = .off // Turn off torch
            }
            device.unlockForConfiguration()
        } catch {
            print("Torch could not be used: \(error)")
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
