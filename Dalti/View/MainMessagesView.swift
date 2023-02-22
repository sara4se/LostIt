//
//  MainMessagesView.swift
//  Dalti
//
//  Created by Rawan on 24/07/1444 AH.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseFirestoreSwift

class MainMessagesViewModel: ObservableObject {
    //checked
    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?
    @Published var isUserCurrentlyLoggedOut = false
    //@Published var isUserCurrentlyLoggedIn = true
    
    init() {
        
        func application (_ application : UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken : Data){
            print("deviceToken token :\(deviceToken.map({String(format: "%02.2hhx", $0)}).joined())")
            chatUser?.TokenDiv = deviceToken.map({String(format: "%02.2hhx", $0)}).joined()
        }
        DispatchQueue.main.async {
            self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
           // self.isUserCurrentlyLoggedIn = FirebaseManager.shared.auth.currentUser?.uid != nil
        }
        
        fetchCurrentUser()
        
        fetchRecentMessages()
    }
    
    @Published var recentMessages = [RecentMessage]()
    
    private var firestoreListener: ListenerRegistration?
    
    func fetchRecentMessages() {
        
        firestoreListener?.remove()
        self.recentMessages.removeAll()
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        firestoreListener = FirebaseManager.shared.firestore.collection("Community")
            .document("Users").collection(FirebaseConstants.users)
            .document(uid)
            .collection(FirebaseConstants.recentMessages)
            .document(uid)
            .collection(FirebaseConstants.messages)
            .order(by: FirebaseConstants.timestamp)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for recent messages: \(error)"
                    print(error)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    let docId = change.document.documentID
                    
                    if let index = self.recentMessages.firstIndex(where: { rm in
                        return rm.id == docId
                    }) {
                        self.recentMessages.remove(at: index)
                    }
                    
                    do {
                        if let rm = try? change.document.data(as: RecentMessage.self) {
                            self.recentMessages.insert(rm, at: 0)
                        }
                    } catch {
                        print(error)
                    }
                })
            }
    }
    
    func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }
        FirebaseManager.shared.firestore.collection("Community").document("Users")
            .collection(FirebaseConstants.users).document(uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user:", error)
                return
            }
            
            self.chatUser = try? snapshot?.data(as: ChatUser.self)
            FirebaseManager.shared.currentUser = self.chatUser
        }
    }
    
    func handleSignOut() {
        isUserCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }
    
}

struct MainMessagesView: View {
    
    @State var shouldShowLogOutOptions = false
    //@Binding var Show: Bool
    @State var shouldNavigateToChatLogView = false
    
    @ObservedObject private var vm = MainMessagesViewModel()
    
    private var chatLogViewModel = ChatLogViewModel(chatUser: nil)
//    @ObservedObject var viewModelChat : ChatViewModel = ChatViewModel()
    var body: some View {
        NavigationStack {
            
            VStack {
                customNavBar
                messagesView
                
                NavigationLink("", isActive: $shouldNavigateToChatLogView) {
                    ChatLogView(vm: chatLogViewModel)
                }
            }
            .overlay(
                newMessageButton, alignment: .bottom)
            .navigationBarHidden(true)
            
             .navigationBarTitle("Chat", displayMode: .large)
        }
    }
    
    private var customNavBar: some View {
        HStack(spacing: 16) {
            
            WebImage(url: URL(string: vm.chatUser?.profileImageUrl ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipped()
                .cornerRadius(50)
                .overlay(RoundedRectangle(cornerRadius: 44)
                    .stroke(Color(.label), lineWidth: 1)
                )
                .shadow(radius: 5)
            
            
            VStack(alignment: .leading, spacing: 4) {
                let email = vm.chatUser?.email.replacingOccurrences(of: "@gmail.com", with: "") ?? ""
                Text(email)
                    .font(.system(size: 24, weight: .bold))
                
                HStack {
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 14, height: 14)
                    Text("online")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.lightGray))
                }
                
            }
            
            Spacer()
            Button {
                shouldShowLogOutOptions.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.label))
            }
        }
        .padding()
        .actionSheet(isPresented: $shouldShowLogOutOptions) {
            .init(title: Text("Settings"), message: Text("What do you want to do?"), buttons: [
                .destructive(Text("Sign Out"), action: {
                    print("handle sign out")
                    vm.handleSignOut()
                }),
                .cancel()
            ])
        }
 
        
        .fullScreenCover(isPresented: $vm.isUserCurrentlyLoggedOut, onDismiss: nil) {
            Chat(didCompleteLoginProcess: {
                self.vm.isUserCurrentlyLoggedOut = false
                self.vm.fetchCurrentUser()
                self.vm.fetchRecentMessages()
            })
//            if(viewModelChat.didCompleteLoginProcess){
//                self.vm.isUserCurrentlyLoggedOut = false
//                self.vm.fetchCurrentUser()
//                self.vm.fetchRecentMessages()
//                Chat(viewModelChat: ChatViewModel())
//            }
        
        }
    }

        
        private var messagesView: some View {
            ScrollView {
                ForEach(vm.recentMessages) { recentMessage in
                    VStack {
                        Button {
                            let uid = FirebaseManager.shared.auth.currentUser?.uid == recentMessage.fromId ? recentMessage.toId : recentMessage.fromId
                            
                            self.chatUser = .init(id: uid, uid: uid, email: recentMessage.email, profileImageUrl: recentMessage.profileImageUrl)
                            
                            self.chatLogViewModel.chatUser = self.chatUser
                            self.chatLogViewModel.fetchMessages()
                            self.shouldNavigateToChatLogView.toggle()
                        } label: {
                            HStack(spacing: 16) {
                                WebImage(url: URL(string: recentMessage.profileImageUrl))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 64, height: 64)
                                    .clipped()
                                    .cornerRadius(64)
                                    .overlay(RoundedRectangle(cornerRadius: 64)
                                        .stroke(Color.black, lineWidth: 1))
                                    .shadow(radius: 5)
                                
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(recentMessage.username)
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(Color(.label))
                                        .multilineTextAlignment(.leading)
                                    Text(recentMessage.text)
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(.darkGray))
                                        .multilineTextAlignment(.leading)
                                }
                                Spacer()
                                
                                Text(recentMessage.timeAgo)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color(.label))
                            }
                        }
                        
                        
                        
                        Divider()
                            .padding(.vertical, 8)
                    }.padding(.horizontal)
                    
                }.padding(.bottom, 50)
            }
        }
        
        @State var shouldShowNewMessageScreen = false
        
        private var newMessageButton: some View {
            Button {
                shouldShowNewMessageScreen.toggle()
            } label: {
                HStack {
                    Spacer()
                    Text("+ New Message")
                        .foregroundColor(.white)
                         
                    
                    Spacer()
                }
                .foregroundColor(.white)
                .padding(.vertical)
                .background(Color("Mygreen"))
                .cornerRadius(3.0)
                .padding(.horizontal)
                .shadow(radius: 3)

            }
            .fullScreenCover(isPresented: $shouldShowNewMessageScreen) {
                NewMessageView(didSelectNewUser: { user in
                    print(user.email)
                    self.shouldNavigateToChatLogView.toggle()
                    self.chatUser = user
                    self.chatLogViewModel.chatUser = user
                    self.chatLogViewModel.fetchMessages()
                })
            }
        }
        
        @State var chatUser: ChatUser?
    }
    
    struct MainMessagesView_Previews: PreviewProvider {
        static var previews: some View {
            MainMessagesView()
                .preferredColorScheme(.dark)
            
        }
    }
