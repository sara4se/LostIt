//
//  ContentView.swift
//  Dalti
//
//  Created by Sara Alhumidi on 10/07/1444 AH.
//

import SwiftUI

struct SignIn: View {
    @State var itemType = ["Lost","Found"]
    @State var  ItemType = ""
   // @Binding var Show: Bool
    var body: some View {
        NavigationStack{
       
            ZStack{
//                Color("BackGroundColor").ignoresSafeArea()
            }
            NavigationLink {
                // destination view to navigation to
                Community()
            } label: {
                
            }
            .navigationTitle("Sign In")
        }
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn()
    }
}
