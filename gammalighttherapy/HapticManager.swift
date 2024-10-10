//
//  HapticManager.swift
//  gammalighttherapy
//
//  Created by Tamilarasan on 10/10/24.
//

import CoreHaptics
import SwiftUI

class HapticManager {
    private var hapticEngine: CHHapticEngine?
    private var hapticPlayer: CHHapticPatternPlayer?

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
        
        var events = [CHHapticEvent]()
        
        // 40Hz means a vibration every 0.025 seconds (1/40 seconds)
        let duration: TimeInterval = 0.025
        
        for i in stride(from: 0.0, to: 1.0, by: duration) {
            let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5),
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
            ], relativeTime: i, duration: duration)
            
            events.append(event)
        }

        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            hapticPlayer = try hapticEngine?.makePlayer(with: pattern)
            try hapticPlayer?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription)")
        }
    }

    func stopHaptic() {
        do {
            try hapticPlayer?.stop(atTime: CHHapticTimeImmediate)
        } catch {
            print("Failed to stop haptic pattern: \(error.localizedDescription)")
        }
    }
}
