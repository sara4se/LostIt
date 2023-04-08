//
//  ChatLogView.swift
//  LBTASwiftUIFirebaseChat
//
//  Created by Rawan on 25/07/1444 AH.
//

import SwiftUI
import Firebase
import FirebaseFirestore

class ChatLogViewModel: ObservableObject {
    
    @Published var chatText = ""
    @Published var errorMessage = ""
    
    @Published var chatMessages = [ChatMessage]()
    
    var chatUser: ChatUser?
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        
        fetchMessages()
    }
    
    var firestoreListener: ListenerRegistration?
    
    func fetchMessages() {
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = chatUser?.uid else { return }
        firestoreListener?.remove()
        chatMessages.removeAll()
        firestoreListener = FirebaseManager.shared.firestore
            .collection(FirebaseConstants.messages)
            .document(fromId)
            .collection(toId)
            .order(by: FirebaseConstants.timestamp)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for messages: \(error)"
                    print(error)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        do {
                            if let cm = try? change.document.data(as: ChatMessage.self) {
                                self.chatMessages.append(cm)
                                print("Appending chatMessage in ChatLogView: \(Date())")
                            }
                        } catch {
                            print("Failed to decode message: \(error)")
                        }
                    }
                })
                
                DispatchQueue.main.async {
                    self.count += 1
                }
            }
    }
    
    func handleSend() {
        print(chatText)
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        guard let toId = chatUser?.uid else { return }
        
        let document = FirebaseManager.shared.firestore.collection(FirebaseConstants.messages)
            .document(fromId)
            .collection(toId)
            .document()
        
        let msg = ChatMessage(id: nil, fromId: fromId, toId: toId, text: chatText, timestamp: Date())
        
        try? document.setData(from: msg) { error in
            if let error = error {
                print(error)
                self.errorMessage = "Failed to save message into Firestore: \(error)"
                return
            }
            
            print("Successfully saved current user sending message")
            
            self.persistRecentMessage()
            
            self.chatText = ""
            self.count += 1
        }
        
        let recipientMessageDocument = FirebaseManager.shared.firestore.collection("messages")
            .document(toId)
            .collection(fromId)
            .document()
        
        try? recipientMessageDocument.setData(from: msg) { error in
            if let error = error {
                print(error)
                self.errorMessage = "Failed to save message into Firestore: \(error)"
                return
            }
            
            print("Recipient saved message as well")
        }
    }
    
    private func persistRecentMessage() {
        guard let chatUser = chatUser else { return }
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = self.chatUser?.uid else { return }
        
        let document = FirebaseManager.shared.firestore
            .collection(FirebaseConstants.recentMessages)
            .document(uid)
            .collection(FirebaseConstants.messages)
            .document(toId)
        
        let data = [
            FirebaseConstants.timestamp: Timestamp(),
            FirebaseConstants.text: self.chatText,
            FirebaseConstants.fromId: uid,
            FirebaseConstants.toId: toId,
            FirebaseConstants.profileImageUrl: chatUser.profileImageUrl,
            FirebaseConstants.email: chatUser.email
        ] as [String : Any]
        
        // you'll need to save another very similar dictionary for the recipient of this message...how?
        
        document.setData(data) { error in
            if let error = error {
                self.errorMessage = "Failed to save recent message: \(error)"
                print("Failed to save recent message: \(error)")
                return
            }
        }
        
        guard let currentUser = FirebaseManager.shared.currentUser else { return }
        let recipientRecentMessageDictionary = [
            FirebaseConstants.timestamp: Timestamp(),
            FirebaseConstants.text: self.chatText,
            FirebaseConstants.fromId: uid,
            FirebaseConstants.toId: toId,
            FirebaseConstants.profileImageUrl: currentUser.profileImageUrl,
            FirebaseConstants.email: currentUser.email
        ] as [String : Any]
        
        FirebaseManager.shared.firestore
            .collection(FirebaseConstants.recentMessages)
            .document(toId)
            .collection(FirebaseConstants.messages)
            .document(currentUser.uid)
            .setData(recipientRecentMessageDictionary) { error in
                if let error = error {
                    print("Failed to save recipient recent message: \(error)")
                    return
                }
            }
    }
    
    @Published var count = 0
}

struct ChatLogView: View {
    
//    let chatUser: ChatUser?
//
//    init(chatUser: ChatUser?) {
//        self.chatUser = chatUser
//        self.vm = .init(chatUser: chatUser)
//    }
    
    @ObservedObject var vm: ChatLogViewModel
        @State var shouldShowLogOutOptions = false
        @AppStorage("Blocked") var blockedchat = false
    var body: some View {
        ZStack {
            messagesView
            Text(vm.errorMessage)
        }
        .navigationTitle(vm.chatUser?.email ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            Button {
                
                shouldShowLogOutOptions.toggle()
            } label: {
                Label("Profile", systemImage: "ellipsis")
            } .actionSheet(isPresented: $shouldShowLogOutOptions) {
                .init(title: Text("Block User"), message: Text("Do you want to Block this user?"), buttons: [
                    .destructive(Text("Block"), action: {
                        print("handle Block")
                        blockedchat.toggle()
                    }),
                    .cancel()
                ])
            }
            
        }
     
        .onDisappear {
            vm.firestoreListener?.remove()
        }
    }
    
    static let emptyScrollToString = "Empty"
    
    private var messagesView: some View {
        VStack {
            if #available(iOS 15.0, *) {
                ScrollView {
                    ScrollViewReader { scrollViewProxy in
                        VStack {
                            ForEach(vm.chatMessages) { message in
                                MessageView(message: message)
                            }
                            
                            HStack{ Spacer() }
                            .id(Self.emptyScrollToString)
                        }
                        .onReceive(vm.$count) { _ in
                            withAnimation(.easeOut(duration: 0.5)) {
                                scrollViewProxy.scrollTo(Self.emptyScrollToString, anchor: .bottom)
                            }
                        }
                    }
                }
                .background(Color(.init(white: 0.95, alpha: 1)))
                .safeAreaInset(edge: .bottom) {
                    if (!blockedchat){
                       
                        chatBottomBar
                        .background(Color(.systemBackground).ignoresSafeArea())}
                }
            } else {
                
            }
        }
    }
    
    private var chatBottomBar: some View {
        HStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 24))
                .foregroundColor(Color(.darkGray))
            ZStack {
                DescriptionPlaceholder()
                TextEditor(text: $vm.chatText)
                    .opacity(vm.chatText.isEmpty ? 0.5 : 1)
            }
            .frame(height: 40)
            
            Button {
                vm.handleSend()
            } label: {
                Text("Send")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color("Mygreen"))
            .cornerRadius(4)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

struct MessageView: View {
    
    let message: ChatMessage
    
    var body: some View {
        VStack {
            if message.fromId == FirebaseManager.shared.auth.currentUser?.uid {
                HStack {
                    Spacer()
                    HStack {
                        Text(message.text)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color("Mygreen"))
                    .cornerRadius(8)
                }
            } else {
                HStack {
                    HStack {
                        Text(message.text)
                            .foregroundColor(.black)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    Spacer()
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

private struct DescriptionPlaceholder: View {
    var body: some View {
        HStack {
            Text("Description")
                .foregroundColor(Color(.gray))
                .font(.system(size: 17))
                .padding(.leading, 5)
                .padding(.top, -4)
            Spacer()
        }
    }
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
//        NavigationView {
//            ChatLogView(chatUser: .init(data: ["uid": "R8ZrxIT4uRZMVZeWwWeQWPI5zUE3", "email": "waterfall1@gmail.com"]))
//        }
        MainMessagesView()
    }
}
//
//class ChatLogViewModel: ObservableObject {
//    //checked
//    @Published var chatText = ""
//    @Published var errorMessage = ""
//
//    @Published var chatMessages = [ChatMessage]()
//
//    var chatUser: ChatUser?
//
//    init(chatUser: ChatUser?) {
//        self.chatUser = chatUser
//
//        fetchMessages()
//    }
//
//    var firestoreListener: ListenerRegistration?
//
//    func fetchMessages() {
//        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
//        guard let toId = chatUser?.uid else { return }
//        firestoreListener?.remove()
//        chatMessages.removeAll()
//      firestoreListener = FirebaseManager.shared.firestore
//            .collection("Community")
//            .document("Users")
//            .collection(FirebaseConstants.users)
//            .document(fromId)
////        FirebaseManager.shared.firestore
//            .collection(FirebaseConstants.messages)
//            .document(fromId)
//            .collection(toId)
//            .order(by: FirebaseConstants.timestamp)
//            .addSnapshotListener { querySnapshot, error in
//                if let error = error {
//                    self.errorMessage = "Failed to listen for messages"
//                    print(error)
//                    return
//                }
//
//                querySnapshot?.documentChanges.forEach({ change in
//                    if change.type == .added {
//                        do {
//                            if let cm = try? change.document.data(as: ChatMessage.self) {
//                                self.chatMessages.append(cm)
//                                print("Appending chatMessage in ChatLogView: \(Date())")
//                            }
//                        } catch {
//                            print("Failed to decode message")
//                        }
//                    }
//                })
//
//                DispatchQueue.main.async {
//                    self.count += 1
//                }
//            }
//    }
//
//    func handleSend() {
//        print(chatText)
//        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
//
//        guard let toId = chatUser?.uid else { return }
//
//        let document = FirebaseManager.shared.firestore.collection("Community")
//            .document("Users")
//            .collection(FirebaseConstants.users).document(fromId).collection(FirebaseConstants.messages)
//            .document(fromId)
//            .collection(toId)
//            .document()
//
//        let msg = ChatMessage(id: nil, fromId: fromId, toId: toId, text: chatText, timestamp: Date())
//
//        try? document.setData(from: msg) { error in
//            if let error = error {
//                print(error)
//                self.errorMessage = "Failed to save message into Firestore"
//                return
//            }
//
//            print("Successfully saved current user sending message")
//
//            self.persistRecentMessage()
//
//            self.chatText = ""
//            self.count += 1
//        }
//
//        let recipientMessageDocument =  FirebaseManager.shared.firestore.collection("Community")
//            .document("Users")
//            .collection(FirebaseConstants.users).document(fromId).collection(FirebaseConstants.messages)
//            .document(toId)
//            .collection(fromId)
//            .document()
//
//        try? recipientMessageDocument.setData(from: msg) { error in
//            if let error = error {
//                print(error)
//                self.errorMessage = "Failed to save message into Firestore: \(error)"
//                return
//            }
//
//            print("Recipient saved message as well")
//        }
//    }
//
//    private func persistRecentMessage() {
//        guard let chatUser = chatUser else { return }
//        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
//
//      //  guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
//        guard let toId = self.chatUser?.uid else { return }
////        firestoreListener = FirebaseManager.shared.firestore.collection("Community")
////            .document("Users")
////            .collection(FirebaseConstants.users)
////            .document(fromId)
//////        FirebaseManager.shared.firestore
////            .collection(FirebaseConstants.messages)
////            .document(fromId)
////            .collection(toId)
//        let document = FirebaseManager.shared.firestore.collection("Community")
//            .document("Users")
//            .collection(FirebaseConstants.users)
//            .document(fromId)
//            .collection(FirebaseConstants.recentMessages)
//            .document(fromId)
//            .collection(toId).document()
//
////            .document(uid)
////            .collection(FirebaseConstants.messages)
////            .document(toId)
////
//        let data = [
//            FirebaseConstants.timestamp: Timestamp(),
//            FirebaseConstants.text: self.chatText,
//            FirebaseConstants.fromId: fromId,
//            FirebaseConstants.toId: toId,
//            FirebaseConstants.profileImageUrl: chatUser.profileImageUrl,
//            FirebaseConstants.email: chatUser.email
//        ] as [String : Any]
//
//        // you'll need to save another very similar dictionary for the recipient of this message...how?
//
//        document.setData(data) { error in
//            if let error = error {
//                self.errorMessage = "Failed to save recent message"
//                print("Failed to save recent message")
//                return
//            }
//        }
//
////        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
//        guard let currentUser = FirebaseManager.shared.currentUser else { return }
//        let recipientRecentMessageDictionary = [
//            FirebaseConstants.timestamp: Timestamp(),
//            FirebaseConstants.text: self.chatText,
//            FirebaseConstants.fromId: fromId,
//            FirebaseConstants.toId: toId,
//            FirebaseConstants.profileImageUrl: currentUser.profileImageUrl,
//            FirebaseConstants.email: currentUser.email
//        ] as [String : Any]
//
//        FirebaseManager.shared.firestore.collection("Community").document("Users")
//            .collection(FirebaseConstants.users).document(currentUser.uid)
//            .collection(FirebaseConstants.recentMessages)
//            .document(toId)
//            .collection(fromId)
//            .document()
//            .setData(recipientRecentMessageDictionary) { error in
//                if let error = error {
//                    print("Failed to save recipient recent message")
//                    return
//                }
//            }
//    }
//
//    @Published var count = 0
//}
//
//struct ChatLogView: View {
//
////    let chatUser: ChatUser?
////
////    init(chatUser: ChatUser?) {
////        self.chatUser = chatUser
////        self.vm = .init(chatUser: chatUser)
////    }
//
//    @ObservedObject var vm: ChatLogViewModel
//    @State var shouldShowLogOutOptions = false
//    @AppStorage("Blocked") var blockedchat = false
//    var body: some View {
//        ZStack {
//            messagesView
//            Text(vm.errorMessage)
//        }
//        .navigationTitle(vm.chatUser?.email ?? "")
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar{
//            Button {
//                shouldShowLogOutOptions.toggle()
//            } label: {
//                Label("Profile", systemImage: "ellipsis")
//            } .actionSheet(isPresented: $shouldShowLogOutOptions) {
//                .init(title: Text("Block User"), message: Text("Do you want to Block this user?"), buttons: [
//                    .destructive(Text("Block"), action: {
//                        print("handle Block")
//                        blockedchat.toggle()
//                    }),
//                    .cancel()
//                ])
//            }
//
//        }
//        .onDisappear {
//            vm.firestoreListener?.remove()
//        }
//    }
//
//    static let emptyScrollToString = "Empty"
//
//    private var messagesView: some View {
//        VStack {
//            if #available(iOS 15.0, *) {
//                ScrollView {
//                    ScrollViewReader { scrollViewProxy in
//                        VStack {
//                            ForEach(vm.chatMessages) { message in
//                                MessageView(message: message)
//                            }
//
//                            HStack{ Spacer() }
//                            .id(Self.emptyScrollToString)
//                        }
//                        .onReceive(vm.$count) { _ in
//                            withAnimation(.easeOut(duration: 0.5)) {
//                                scrollViewProxy.scrollTo(Self.emptyScrollToString, anchor: .bottom)
//                            }
//                        }
//                    }
//                }
//                .background(Color(.init(white: 0.95, alpha: 1)))
//                .safeAreaInset(edge: .bottom) {
//                    chatBottomBar
//                        .background(Color(.systemBackground).ignoresSafeArea())
//                }
//            } else {
//                // Fallback on earlier versions
//            }
//        }
//    }
//
//    private var chatBottomBar: some View {
//        HStack(spacing: 16) {
////            Image(systemName: "photo.on.rectangle")
////                .font(.system(size: 24))
////                .foregroundColor(Color(.darkGray))
//            ZStack {
//                if (!blockedchat){
//                    DescriptionPlaceholder()
//                    TextEditor(text: $vm.chatText)
//                    .opacity(vm.chatText.isEmpty ? 0.5 : 1)}
//                else{Text("this user blocked")}
//            }
//            .frame(height: 40)
//
//            Button {
//                if (!blockedchat){
//                    vm.handleSend()}
//            } label: {
//                Text("Send")
//                    .foregroundColor(.white)
//            }
//            .padding(.horizontal)
//            .padding(.vertical, 8)
//            .background(blockedchat ? Color.gray : Color.blue)
//            .cornerRadius(4)
//        }
//        .padding(.horizontal)
//        .padding(.vertical, 8)
//    }
//}
//
//struct MessageView: View {
//
//    let message: ChatMessage
//
//    var body: some View {
//        VStack {
//            if message.fromId == FirebaseManager.shared.auth.currentUser?.uid {
//                HStack {
//                    Spacer()
//                    HStack {
//                        Text(message.text)
//                            .foregroundColor(.white)
//                    }
//                    .padding()
//                    .background(Color.blue)
//                    .cornerRadius(8)
//                }
//            } else {
//                HStack {
//                    HStack {
//                        Text(message.text)
//                            .foregroundColor(.black)
//                    }
//                    .padding()
//                    .background(Color.white)
//                    .cornerRadius(8)
//                    Spacer()
//                }
//            }
//        }
//        .padding(.horizontal)
//        .padding(.top, 8)
//    }
//}
//
//private struct DescriptionPlaceholder: View {
//    var body: some View {
//        HStack {
//            Text("Description")
//                .foregroundColor(Color(.gray))
//                .font(.system(size: 17))
//                .padding(.leading, 5)
//                .padding(.top, -4)
//            Spacer()
//        }
//    }
//}
//
//struct ChatLogView_Previews: PreviewProvider {
//    static var previews: some View {
////        NavigationView {
////            ChatLogView(chatUser: .init(data: ["uid": "R8ZrxIT4uRZMVZeWwWeQWPI5zUE3", "email": "waterfall1@gmail.com"]))
////        }
//        MainMessagesView()
//    }
//}
