//
//  Community.swift
//  Dalti
//
//  Created by Sara Alhumidi on 10/07/1444 AH.
//

import SwiftUI

struct Community: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        NavigationStack{
            ZStack {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }
         
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                                    HStack {
                NavigationLink(destination: Profile(), label:{
                    Label("Profile", systemImage: "person.circle")
                        .foregroundColor(.black)
                })
            }, trailing:
                                    HStack {
                NavigationLink(destination: Chat(), label:{
                    Label("Chat", systemImage: "message")
                        .foregroundColor(.black)
                })
                
                NavigationLink(destination: Post(), label:{
                    Label("Post", systemImage: "plus")
                        .foregroundColor(.black)
                })
            })
            
            //.navigationBarItems(leading: btnBack)
            .navigationBarTitle("Community", displayMode: .large)
            
            
        }
    }
}

struct Community_Previews: PreviewProvider {
    static var previews: some View {
        Community()
    }
}
