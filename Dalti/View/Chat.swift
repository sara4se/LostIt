//
//  Chat.swift
//  Dalti
//
//  Created by Sara Alhumidi on 10/07/1444 AH.
//

import SwiftUI

struct Chat: View {
    var body: some View {
        NavigationStack{
            ZStack {
                Text("Chat Page")
            }.toolbar{
                
                NavigationLink(destination: Post(), label:{
                    Label("Post", systemImage: "plus")
                        .foregroundColor(.black)
                })
            }
            .navigationBarTitle("Chat", displayMode: .large)
        }
    }
}

struct Chat_Previews: PreviewProvider {
    static var previews: some View {
        Chat()
    }
}
