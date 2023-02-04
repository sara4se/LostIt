//
//  Post.swift
//  Dalti
//
//  Created by Sara Alhumidi on 10/07/1444 AH.
//

import SwiftUI

struct Post: View {
    var body: some View {
        NavigationStack{
            ZStack {
                Text("Post Page")
            }.toolbar{
                NavigationLink(destination: Chat(), label:{
                    Label("Chat", systemImage: "message")
                        .foregroundColor(.black)
                })
            }
            .navigationBarTitle("Post", displayMode: .large)
        }
        
        
    }
}

struct Post_Previews: PreviewProvider {
    static var previews: some View {
        Post()
    }
}
