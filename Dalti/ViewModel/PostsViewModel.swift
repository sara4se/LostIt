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
            listenerRegistration = db.collection("Posts").addSnapshotListener { (querySnapshot, error) in
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
    
// 
//    func downloadImageFunc(){
//        Storage.storage().reference().child("temp").getData(maxSize: 12 * 1024 * 1024) { (data,error) in
//            if let error = error{
//                print("an error has occurrd - \(error.localizedDescription)")
//            }else {
//                if let imageData = data{
//                    // self.postToFB.ImageURL = UIImage(data: imageData)
//                    //                    print("image download successfully")
//                }
//                else{
//                    print("could't unwrap/case image to data")
//                }
//            }
//        }
//    }
    
}
