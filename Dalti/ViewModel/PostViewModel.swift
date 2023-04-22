//
//  PostViewModel.swift
//  Dalti
//
//  Created by Sara Alhumidi on 20/07/1444 AH.
//

import Foundation
import FirebaseFirestore
import Combine
import SwiftUI
import UIKit
import FirebaseStorage
class PostViewModel: ObservableObject {
    
    @Published var post: PostModel
    @Published var modified = false
    //  @Published  var arr : String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init(post: PostModel = PostModel(ItemName: "", ItemState: "", Description: "",ImageURL: "",Phone: "", report: "",  timestamp: Date())) {
        self.post = post
        
        self.$post
            .dropFirst()
            .sink { [weak self] post in
                self?.modified = true
            }
            .store(in: &self.cancellables)
    }
    
    var db = Firestore.firestore()
    
      func removePost() {
//        let id = self.db.collection("Community").document().documentID
         
        let idPost = self.db.collection("Post").document().documentID
          print("i delete post")
        self.db.collection("Community").document("Posts").collection("Post").document(idPost).delete { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        
    }
    
    func uploadImageToStorge(uuimage :UIImage?,ItemName: String, ItemState: String, Description: String, Phone : String, report: String) {
        guard uuimage != nil else{
            return
        }
        let storgeRef = Storage.storage().reference()
        let imageDate = uuimage!.jpegData(compressionQuality: 0.8)
        guard imageDate != nil else{
            return
        }
        let path = "images/\(UUID().uuidString)"
        let fileRef = storgeRef.child(path)
        let meata = StorageMetadata()
        meata.contentType = "image/jpeg"
        fileRef.putData(imageDate!, metadata: meata) {
            (data, err) in
            if err == nil && data != nil {
                fileRef.downloadURL { downloadUrl, error in
                    if error == nil {
                        print("this is your data after put it in the storge : \(data.debugDescription)")
                        print("this is your url after put it in the storge : \(String(describing: downloadUrl?.absoluteString))")
                            guard let url = downloadUrl?.absoluteString else {return}
                        let post = PostModel(ItemName: ItemName, ItemState: ItemState, Description: Description, ImageURL: url,Phone: Phone, report: report, timestamp: Date())
                        print("this is your post after put it in the storge : \(String(describing: post))")
                        let id = self.db.collection("Community").document().documentID
                        let idPost = self.db.collection("Post").document().documentID
                        print("this is your id after put it in the storge : \(String(describing: id))")
                      //  guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
                        self.db.collection("Community").document("Posts").collection("Post").document(idPost).setData(["Description":post.Description,"ImageURL": post.ImageURL,"ItemName": post.ItemName, "ItemState": post.ItemState, "id": idPost,"Phone": post.Phone, "report": post.report , "timestamp": post.timestamp])
//                        db.collection("users").document(fromId).collection("Posts") after
//                        db.collection("Posts").document("Post").collection(fromId) before
                        
                    }
                }
            }
        }
    }
    func handleDeleteTapped() {
        self.removePost()
    }
}
