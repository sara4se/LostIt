//
//  ContentView.swift
//  Dalti
//
//  Created by Sara Alhumidi on 10/07/1444 AH.
//

import SwiftUI

struct SignIn: View {
    
    var body: some View {
        NavigationStack{
            
            NavigationLink {
                // destination view to navigation to
                Community()
            } label: {
                Text("Sign Up Page")
                Text("Sign Up Page")
                    .foregroundColor(.gray)
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
