//
//  FlashLightView.swift
//  gammalighttherapy
//
//  Created by Tamilarasan on 11/10/24.
//

import SwiftUI

struct FlashLightView: View {
    @State private var isFlashing = false
    let fashLightManager = FlashLightManager()
    let hapticManager = HapticManager()
    
    var body: some View {
        Button(action: {
            isFlashing.toggle()
            if isFlashing {
                fashLightManager.startFlashing()
                hapticManager.playHapticAt40Hz()
            } else {
                fashLightManager.stopFlashing()
                hapticManager.stopHaptic()
            }
        }) {
            Image(systemName: isFlashing ? "lightbulb.fill" : "lightbulb")
                .resizable()
                .frame(width: 25, height: 32)
                .foregroundColor(isFlashing ? .yellow : Color(hex: "f0f0f0"))
                .padding()
        }
        
    }
}

#Preview {
    FlashLightView()
}
