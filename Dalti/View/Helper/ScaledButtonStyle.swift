//
//  ScaledButtonStyle.swift
//  Dalti
//
//  Created by Sara Alhumidi on 14/07/1444 AH.
//

import SwiftUI

struct ScaledButtonStyle: ButtonStyle{
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}
