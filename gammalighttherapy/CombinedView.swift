//
//  CombinedView.swift
//  gammalighttherapy
//
//  Created by Tamilarasan on 11/10/24.
//

import SwiftUI

struct CombinedView: View {
    @State private var isCombined = false
    let audioManager = AudioManager()
    let flashLightManager = FlashLightManager()
    let hapticManager = HapticManager()
    
    var body: some View {
        Button(action: {
            isCombined.toggle()
            if isCombined {
                flashLightManager.startFlashing()
                hapticManager.playHapticAt40Hz()
                audioManager.playSound()
            } else {
                flashLightManager.stopFlashing()
                hapticManager.stopHaptic()
                audioManager.stopSound()
            }
        }) {
            Image(isCombined ? "competence" : "competence-off")
                .resizable()
                .frame(width: 32, height: 32)
                .padding()
        }
    }
}

#Preview {
    CombinedView()
}
