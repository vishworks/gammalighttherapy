//
//  FlashLightManager.swift
//  gammalighttherapy
//
//  Created by Tamilarasan on 11/10/24.
//

import SwiftUI
import AVFoundation

class FlashLightManager {
    private var flashTimer: Timer?
    private let flashRate: Double = 1.0 / 40.0
    
    func startFlashing() {
        flashTimer = Timer.scheduledTimer(withTimeInterval: flashRate, repeats: true) { _ in
            self.toggleTorch(on: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + self.flashRate) {
                self.toggleTorch(on: false)
            }
        }
    }

    func stopFlashing() {
        self.toggleTorch(on: false)
        flashTimer?.invalidate()
        flashTimer = nil
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
}
