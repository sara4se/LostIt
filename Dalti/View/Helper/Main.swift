//
//  Main.swift
//  Dalti
//
//  Created by Mashael Alharbi on 12/02/2023.
//

import SwiftUI

struct Main: View {
    @State var splashScreen  = true
    var body: some View {
        ZStack{
            Group{
                if splashScreen {
                    Splash()
                }
                else{
                    Post()
                }
            }
            .onAppear {
                DispatchQueue
                    .main
                    .asyncAfter(deadline:
                            .now() + 2.0) {
                                self.splashScreen = false
                            }
            }
        }
    }
            }
struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}
