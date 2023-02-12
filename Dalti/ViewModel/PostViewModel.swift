//
//  PostViewModel.swift
//  Dalti
//
//  Created by Sara Alhumidi on 20/07/1444 AH.
//

import Foundation
import FirebaseFirestore
import Combine
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
