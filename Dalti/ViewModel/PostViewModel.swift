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
class PostViewModel: ObservableObject {
   
  @Published var post: PostModel
  @Published var modified = false
   
  private var cancellables = Set<AnyCancellable>()
   
    init(post: PostModel = PostModel(ItemName: "", ItemState: "", Description: "")) {
    self.post = post
     
    self.$post
      .dropFirst()
      .sink { [weak self] post in
        self?.modified = true
      }
      .store(in: &self.cancellables)
  }
   
  private var db = Firestore.firestore()
   
  private func addPost(_ post: PostModel) {
    do {
      let _ = try db.collection("Posts").addDocument(from: post)
    }
    catch {
      print(error)
    }
  }
   
  private func updatePost(_ post: PostModel) {
    if let documentId = post.id {
      do {
        try db.collection("Posts").document(documentId).setData(from: post)
      }
      catch {
        print(error)
      }
    }
  }
   
  private func updateOrAddPost() {
    if let _ = post.id {
      self.updatePost(self.post)
    }
    else {
      addPost(post)
    }
  }
   
  private func removePost() {
    if let documentId = post.id {
      db.collection("Posts").document(documentId).delete { error in
        if let error = error {
          print(error.localizedDescription)
        }
      }
    }
  }
   
  func handleDoneTapped() {
    self.updateOrAddPost()
  }
   
  func handleDeleteTapped() {
    self.removePost()
  }
   
}
