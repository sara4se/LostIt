//
//  NewMessageViewModel.swift
//  Dalti
//
//  Created by Sara Alhumidi on 03/08/1444 AH.
//

import Foundation

class NewMessageViewModel: ObservableObject {
    //checked
    @Published var users = [ChatUser]()
    @Published var errorMessage = ""
    
    init() {
        fetchAllUsers()
    }
    
    private func fetchAllUsers() {
//        FirebaseManager.shared.firestore.collection("Community")
//            .document("Users").collection(FirebaseConstants.users)
        FirebaseManager.shared.firestore.collection("Community")
            .document("Users").collection("User")
            .getDocuments { documentsSnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to fetch users"
                    print("Failed to fetch users: \(error)")
                    return
                }
                
                documentsSnapshot?.documents.forEach({ snapshot in
                    let user = try? snapshot.data(as: ChatUser.self)
                    if user?.uid != FirebaseManager.shared.auth.currentUser?.uid {
                        self.users.append(user!)
                    }
                    
                })
            }
    }
}
