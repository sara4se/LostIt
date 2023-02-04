//
//  Splash.swift
//  Dalti
//
//  Created by Sara Alhumidi on 10/07/1444 AH.
//

import SwiftUI

struct Splash: View {
     init(){
         UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.init(Color(.black))]
         UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .black
             
         }
    @State private var isActive :Bool = false
    var body: some View {
        ZStack{
            if self.isActive{
                SignUp()
            }
            else{
                ZStack {
                    
                    Text("LOGO")
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation (.easeOut){
                    isActive = true
                }
            }
        }
    }
}

struct Splash_Previews: PreviewProvider {
    static var previews: some View {
        Splash()
    }
}
