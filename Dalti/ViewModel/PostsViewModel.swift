//
//  PostsViewModel.swift
//  Dalti
//
//  Created by Sara Alhumidi on 21/07/1444 AH.
//

import Foundation
import FirebaseFirestore
import Combine
import FirebaseStorage
import UIKit


class PostsViewModel: ObservableObject {
    @Published var posts = [PostModel]()
    
    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    
    deinit {
        unsubscribe()
    }
    
    func unsubscribe() {
        if listenerRegistration != nil {
            listenerRegistration?.remove()
            listenerRegistration = nil
        }
    }
    
    func subscribe() {
        if listenerRegistration == nil {
         //   guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
//            self.db.collection("Posts").document("Post").collection(fromId).document(id)
          
//            self.db.collection("Community").document("Posts")
//            let idPost = self.db.collection("Post").document().documentID
                
            listenerRegistration = db.collection("Community").document("Posts").collection("Post")
                .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                self.posts = documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: PostModel.self)
                }
            }
        }
    }
    func reportPost(report: String,_ post: PostModel) {
        if let documentId = post.id{
        do {
            try db.collection("Community").document("Posts").collection("report").document(documentId).setData(["Description":post.Description,"ImageURL": post.ImageURL,"ItemName": post.ItemName, "ItemState": post.ItemState, "id": post.id,"Phone": post.Phone, "report": post.report ,"reportDescption": report])
        }
        catch {
          print(error)
        }
      }
    }
    func updatePost(report: String,_ post: PostModel) {
        if let documentId = post.id{
        do {
            try db.collection("Community").document("Posts").collection("Post").document(documentId).updateData(["report": report])
        }
        catch {
          print(error)
        }
      }
    }
    func removePosts(atOffsets indexSet: IndexSet) {
        let posts = indexSet.lazy.map { self.posts[$0] }
        posts.forEach { post in
            if let documentId = post.id {
                db.collection("Posts").document(documentId).delete { error in
                    if let error = error {
                        print("Unable to remove document: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
}
