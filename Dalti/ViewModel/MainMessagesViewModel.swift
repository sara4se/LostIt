//
//  MainMessagesViewModel.swift
//  Dalti
//
//  Created by Sara Alhumidi on 03/08/1444 AH.
//

import Foundation
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
//            chatUser?.TokenDiv = deviceToken.map({String(format: "%02.2hhx", $0)}).joined()
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
    
        guard let toId = chatUser?.uid else { return }
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        firestoreListener = FirebaseManager.shared.firestore.collection("Community")
            .document("Users").collection(FirebaseConstants.users)
            .document(uid)
            .collection(FirebaseConstants.recentMessages)
            .document(uid)
            .collection(toId)
//            .document(uid)
//            .collection(FirebaseConstants.messages)
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
