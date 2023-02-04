//
//  SignUn.swift
//  Dalti
//
//  Created by Sara Alhumidi on 10/07/1444 AH.
//

import SwiftUI

struct SignUp: View {
    var body: some View {
        NavigationStack{
            
            NavigationLink {
                // destination view to navigation to
                Community()
            } label: {
                Text("Sign Up Page")
                    .foregroundColor(.gray)
            }
            .navigationBarTitle("Sign Up", displayMode: .large)
        }
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
