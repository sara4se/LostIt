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
            }.background(Color("BackGroundColor"))
                .toolbar{
                
                NavigationLink(destination:  Post(post: PostModel.init(ItemName: "", ItemState: "", Description: "", ImageURL: "")), label:{
                    Label("Post", systemImage: "plus")
                        .foregroundColor(.black)
                })
            }
            .navigationBarTitle("Chat", displayMode: .large)
        }.background(alignment: .top){
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(Color("BackGroundColor"))
                .frame(width: .infinity,height: .infinity)
                .ignoresSafeArea()
        }
        
    }
}

struct Chat_Previews: PreviewProvider {
    static var previews: some View {
        Chat()
    }
}
