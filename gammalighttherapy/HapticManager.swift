//
//  FlashLightManager.swift
//  gammalighttherapy
//
//  Created by Tamilarasan on 11/10/24.
//
import CoreHaptics
import SwiftUI

class HapticManager {
    private var hapticEngine: CHHapticEngine?
    private var hapticTimer: DispatchSourceTimer?
    private var isTimerSuspended = false // Track the timer's suspend state
    
    init() {
        prepareHaptics()
    }

    private func prepareHaptics() {
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
        } catch {
            print("Failed to start the haptic engine: \(error.localizedDescription)")
        }
    }

    func playHapticAt40Hz() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        if (hapticTimer == nil) {
            hapticTimer = DispatchSource.makeTimerSource()
            
            // Set the timer to fire every 0.025 seconds (40Hz)
            hapticTimer?.schedule(deadline: .now(), repeating: 0.025)

            hapticTimer?.setEventHandler { [weak self] in
                self?.triggerHapticFeedback()
            }
            
            // Start the timer
            hapticTimer?.activate()


        }
        else if (isTimerSuspended){
            hapticTimer?.resume()
        }
        isTimerSuspended = false
    }

    private func triggerHapticFeedback() {
        guard let engine = hapticEngine else { return }

        let sharpness: Float = 0.5
        let intensity: Float = 1.0
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [
            CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness),
            CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity)
        ], relativeTime: 0)

        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            print("Failed to play haptic event: \(error.localizedDescription)")
        }
    }

    func stopHaptic() {
        isTimerSuspended = true
        hapticTimer?.suspend()
    }
}
