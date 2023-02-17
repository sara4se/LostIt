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
extension View {
    func safeArea()->UIEdgeInsets{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene
        else{
            return .zero
        }
        guard let safeArea = screen.windows.first?.safeAreaInsets else{
            return .zero
        }
        return safeArea
    }
}

extension View {
    func navigationBarItems<L, C, T>(leading: L, center: C, trailing: T) -> some View where L: View, C: View, T: View {
        self.navigationBarItems(leading:
                                    HStack{
            HStack {
                leading
            }
            .frame(width: 60, alignment: .leading)
            Spacer()
            HStack {
                center
            }
            .frame(width: 300, alignment: .center)
            Spacer()
            HStack {
                //Text("asdasd")
                trailing
            }
            //.background(Color.blue)
            .frame(width: 100, alignment: .trailing)
        }
                                //.background(Color.yellow)
            .frame(width: UIScreen.main.bounds.size.width-32)
        )
    }
}
