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
    
    init(post: PostModel = PostModel(ItemName: "", ItemState: "", Description: "",ImageURL: "")) {
        self.post = post
        
        self.$post
            .dropFirst()
            .sink { [weak self] post in
                self?.modified = true
            }
            .store(in: &self.cancellables)
    }
    
    var db = Firestore.firestore()
    
    private func removePost() {
        let id = self.db.collection("Posts").document().documentID
           // self.uploadImageToStorge(uuimage: placeHolderImage, documentId)
            db.collection("Posts").document(id).delete { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        
    }
    
    func uploadImageToStorge(uuimage :UIImage?,ItemName: String, ItemState: String, Description: String) {
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
                            guard let url = downloadUrl?.absoluteString else {return}
                                let post = PostModel(ItemName: ItemName, ItemState: ItemState, Description: Description, ImageURL: url)
                        let id = self.db.collection("Posts").document().documentID
                        self.db.collection("Posts").document(id).setData(["Description":post.Description,"ImageURL": post.ImageURL,"ItemName": post.ItemName, "ItemState": post.ItemState, "id": id])
   
                    }
                }
            }
        }
    }
    func handleDeleteTapped() {
        self.removePost()
    }
=======
class PostViewModel: ObservableObject {
   
  @Published var post: PostModel
  @Published var modified = false
   
  private var cancellables = Set<AnyCancellable>()
   
    init(post: PostModel = PostModel(ItemName: "", TtemState: "", Description: "")) {
    self.post = post
     
    self.$post
      .dropFirst()
      .sink { [weak self] book in
        self?.modified = true
      }
      .store(in: &self.cancellables)
  }
   
  private var db = Firestore.firestore()
   
  private func addBook(_ post: PostModel) {
    do {
      let _ = try db.collection("Posts").addDocument(from: post)
    }
    catch {
      print(error)
    }
  }
   
  private func updateBook(_ book: PostModel) {
    if let documentId = post.id {
      do {
        try db.collection("Posts").document(documentId).setData(from: book)
      }
      catch {
        print(error)
      }
    }
  }
   
  private func updateOrAddBook() {
    if let _ = post.id {
      self.updateBook(self.post)
    }
    else {
      addBook(post)
    }
  }
   
  private func removeBook() {
    if let documentId = post.id {
      db.collection("Posts").document(documentId).delete { error in
        if let error = error {
          print(error.localizedDescription)
        }
      }
    }
  }
   
  func handleDoneTapped() {
    self.updateOrAddBook()
  }
   
  func handleDeleteTapped() {
    self.removeBook()
  }
   

}
