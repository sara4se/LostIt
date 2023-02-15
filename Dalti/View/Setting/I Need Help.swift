//
//  I Need Help.swift
//  Dalti
//
//  Created by Mashael Alharbi on 13/02/2023.
//

import SwiftUI

struct I_Need_Help: View {
    var body: some View {
        ZStack {
            
            Image("LOGO")
                .resizable()
                .opacity(0.3)
                .frame(width:200, height:200)
                .offset(y: -220)
            VStack {
                Text("Contact Us")
                    .offset(x: -80 , y:40)
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(width: 200, height: 100, alignment: .leading)
                
                Text("If you have any questions or suggestions about Our App, do not hesitate to contact Us via :")
                    .padding()
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                
                Text("Sara.alhumidi4@gmail.com  Milahalfaqeeh@gmail.com  Maoalharbi1@gmail.com  Afnan.m.alharbi@gmail.com   Rawanomar1998@hotmail.com")
                    .foregroundColor(.black)
                    .frame(width: 250, height: 150, alignment: .leading)
                    .offset(x: -30, y: -20)
            }
        }
    }
}
struct I_Need_Help_Previews: PreviewProvider {
    static var previews: some View {
        I_Need_Help()
    }
}
