//
//  Profile.swift
//  Dalti
//
//  Created by Sara Alhumidi on 10/07/1444 AH.
//

import SwiftUI

struct Profile: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Text("Profile Page")
                
            }.toolbar{
                            NavigationLink(destination: Chat(), label:{
                    Label("Chat", systemImage: "message")
                        .foregroundColor(.black)
                })
                                  
                                  NavigationLink(destination: Post(), label:{
                    Label("Post", systemImage: "plus")
                        .foregroundColor(.black)
                })
                
                
            }
            .navigationBarTitle("Profile", displayMode: .large)
        }
        
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
