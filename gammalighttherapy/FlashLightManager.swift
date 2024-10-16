//
//  FlashLightManager.swift
//  gammalighttherapy
//
//  Created by Tamilarasan on 11/10/24.
//

import SwiftUI
import AVFoundation

class FlashLightManager {
    private var flashTimer: DispatchSourceTimer?
    private let flashRate: Double = 1.0 / 40.0
    private var isTimerSuspended = false // Track the timer's suspend state
    private var isFlashlightOn = false
    
    func startFlashing() {
            if (flashTimer == nil) {
                flashTimer = DispatchSource.makeTimerSource()
                
                // Set the timer to fire every 0.025 seconds (40Hz)
                flashTimer?.schedule(deadline: .now(), repeating: self.flashRate)

                flashTimer?.setEventHandler { [weak self] in
                    self?.toggleTorch()
                }
                
                // Start the timer
                flashTimer?.activate()

            }
            else if (isTimerSuspended){
                flashTimer?.resume()
            }
            isTimerSuspended = false
    }

    func stopFlashing() {
        self.toggleTorch(turnOff: true)
        self.isTimerSuspended = true
        self.flashTimer?.suspend()
    }


    private func toggleTorch(turnOff: Bool = false) {
        guard let device = AVCaptureDevice.default(for: .video),
              device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            if (turnOff) {
                device.torchMode = .off
            } else{
                device.torchMode = turnOff || !isFlashlightOn ? .off : .on
                try device.setTorchModeOn(level: 1.0) // Set brightness to maximum
            }
            isFlashlightOn.toggle()
            device.unlockForConfiguration()
        } catch {
            print("Error toggling flashlight: \(error)")
        }
    }
        
}
