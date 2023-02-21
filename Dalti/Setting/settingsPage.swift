//
//  settingsPage.swift
//  Dalti
//
//  Created by Mashael Alharbi on 12/02/2023.
//

import SwiftUI

struct settingsPage: View {
    
    @State private var Currentpassword: String = "Currentpassword"
    @State private var Newpassword: String = "Newpassword"
    @State private var Confirmpassword: String = "Confirmpassword"
    @State private var ShowPassword = false
    @State private var isPresentedFullScreenCover = false
    @State var shouldShowLogOutOptions = false
    @ObservedObject private var vm = MainMessagesViewModel()
    var body: some View {
        NavigationStack {
            VStack {
                Form{
                    Section(header: Text("More Information")) {
                        
                        NavigationLink("Privacy Policy" ,destination: Privacy_Policy())
                      
                        
                        NavigationLink("I Need Help" ,destination: I_Need_Help())
                    }
                    
//                    Section(header: Text("Account Action")) {
//
//                        NavigationLink("Forget Password" ,destination: Text("Forgot my password"))
//
//                        NavigationLink("Blocked" ,destination: Text("People you already bloked"))
//
//
//                        NavigationLink(destination: Delete_account()) {
//                            Text("Delete Account")
//                        }
//                    }
                }
                
                Spacer()
                
                Button("Log Out", action: {
                    
                    shouldShowLogOutOptions = true})
                
                .foregroundColor(.white)
                .frame(width: 350 ,height: 50)
                
                .background(Color.red.opacity(0.9))
                .opacity(0.9)
                .cornerRadius(10)
                .border(Color(.clear))
                .font(.system(size: 16, weight: .bold))
                .padding()
                .actionSheet(isPresented: $shouldShowLogOutOptions) {
                    .init(title: Text("Settings"), message: Text("What do you want to do?"), buttons: [
                        .destructive(Text("Sign Out"), action: {
                            print("handle sign out")
//                            vm.handleSignOut()
                            vm.isUserCurrentlyLoggedOut.toggle()
                        }),
                        .cancel()
                    ])
                }
            }
                .navigationTitle("Setting")
        }
    }
    
}


struct settingsPage_Previews: PreviewProvider {
    static var previews: some View {
        settingsPage()
    }
}
