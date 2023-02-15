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
            //      self.uploadImageToStorge(image: self.post.ImageURL.toImage())
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
    
//    func uploadImageToStorge(postId: PostModel){
//        print("postId:\(postId)")
//        guard image != nil else{
//            return
//        }
//        let storgeRef = Storage.storage().reference()
//        let imageDate = image!.jpegData(compressionQuality: 0.2)
//
//        guard imageDate != nil else{
//            return
//        }
//        //.jpg
//        let path = "images/\(UUID().uuidString)"
//
//        let fileRef = storgeRef.child(path)
//        let meata = StorageMetadata()
//        meata.contentType = "image/jpeg"
//        fileRef.putData(imageDate!, metadata: meata) {
//            (data, err) in
//
//            if err == nil && data != nil {
//                self.post.ImageURL = path
//                // self.db.collection("Posts").document().setData(["url": self.post.ImageURL])
//                print("image upload successfully to storge")
//                print("This is uid:\(String(describing: self.post.id))")
//                fileRef.downloadURL { downloadUrl, error in
//                    if error == nil {
//                        //                               if let _ = self.post.id {
//                        self.post.ImageURL = downloadUrl!.absoluteString
//                        print("This is imageURL :\(String(describing:  self.post.ImageURL))")
//                        print("image upload successfully to store")
//
//
//                        self.db.collection("Posts").getDocuments { doucments, error in
//                            if let error = error {
//                                print(error.localizedDescription)
//                            }
//                            guard let doucments = doucments else { return }
//                            for douc in doucments.documents {
//                                self.db.collection("Posts").document(douc.documentID).setData(["url": downloadUrl?.absoluteString as Any])
//                            }
//
//                        }
//                        }
//
//                    }
//                }
//            }
//        }
    func handelUploadImage(image : UIImage?){
       // uploadImageToStorge(image: image)
    }
  func handleDoneTapped() {
    self.updateOrAddPost()
  }
   
  func handleDeleteTapped() {
    self.removePost()
  }
    
    
 
}

/*
 self.db.collection("Posts").document().setData(["url": downloadUrl?.absoluteString as Any]){ error in
     if let error = error {
         print(error.localizedDescription)
     }
 }
 */
    
//    func retrivevImagefromStorge(){
//        db.collection("Posts").getDocuments { snapShot, error in
//            if error == nil && snapShot != nil{
//                var paths = [String]()
//                for doc in snapShot!.documents{
//                    paths.append(doc["url"] as! String)
//                }
//                for path in paths{
//                    let storgeRef = Storage.storage().reference()
//                    let fileRef = storgeRef.child(path)
//                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
//                        if error == nil{
//                            if let image = UIImage(data: data!){
//                                DispatchQueue.main.async {
//                                    self.arr.append(image)
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//    func uploadImageToStorge(image : UIImage?){
//        guard image != nil else{
//            return
//        }
//        let storgeRef = Storage.storage().reference()
//        let imageDate = image!.jpegData(compressionQuality: 0.8)
//
//            guard imageDate != nil else{
//                return
//            }
//        //.jpg
//        let path = "images/\(UUID().uuidString)"
//
//        let fileRef = storgeRef.child(path)
//        let meata = StorageMetadata()
//        meata.contentType = "image/jpeg"
//            fileRef.putData(imageDate!, metadata: meata) {
//                (data, err) in
//
//                if err == nil && data != nil {
//                    self.post.ImageURL = path
//                    // self.db.collection("Posts").document().setData(["url": self.post.ImageURL])
//                    print("image upload successfully to storge")
//                    print("This is uid:\(String(describing: self.post.id))")
//
//                    fileRef.downloadURL { downloadUrl, error in
//                        if error == nil {
////                            if let documentId = self.post.id {
//                            self.post.ImageURL = downloadUrl!.absoluteString
//                                print("image upload successfully to store")
//                                self.db.collection("Posts").document().setData(["url": downloadUrl?.absoluteString as Any]){ error in
//                                  if let error = error {
//                                    print(error.localizedDescription)
//                                  }
//                                }
//
////                           }
//                        }
//                    }
//
//
//                }
//           }
//        }

//func uploadImageToStorge(_ post: PostModel){
////        guard post.ImageURL != nil else{
////            return
////        }
//    let uiimage = post.ImageURL.toImage()
//    let storgeRef = Storage.storage().reference()
//    let imageDate = uiimage!.jpegData(compressionQuality: 0.8)
////
////            guard imageDate != nil else{
////                return
////            }
//    //.jpg
//    let path = "images/\(UUID().uuidString)"
//
//    let fileRef = storgeRef.child(path)
//    let meata = StorageMetadata()
//    meata.contentType = "image/jpeg"
//        fileRef.putData(imageDate!, metadata: meata) {
//            (data, err) in
//           if err == nil && data != nil {
//                // self.db.collection("Posts").document().setData(["url": self.post.ImageURL])
//                print("image upload successfully to storge")
//                print("This is uid:\(self.post.id)")
//                fileRef.downloadURL { downloadUrl, error in
//                    if error == nil {
//                            if let documentId = self.post.id {
//                                print("image upload successfully to store")
//                                self.db.collection("Posts").document(documentId).setData(["url": downloadUrl?.absoluteString])
//                                { error in
//                                    if let error = error {
//                                        print(error.localizedDescription)
//                                    }
//                                }
//
//                            }
//                    }
//                }
//
//
//            }
//       }
//    }

//func uploadImageToStorge(_ post: PostModel){
////        guard post.ImageURL != nil else{
////            return
////        }
//    let uiimage = post.ImageURL.toImage()
//    let storgeRef = Storage.storage().reference()
//    let imageDate = uiimage!.jpegData(compressionQuality: 0.8)
////
////            guard imageDate != nil else{
////                return
////            }
//    //.jpg
//    let path = "images/\(UUID().uuidString)"
//
//    let fileRef = storgeRef.child(path)
//    let meata = StorageMetadata()
//    meata.contentType = "image/jpeg"
//        fileRef.putData(imageDate!, metadata: meata) {
//            (data, err) in
//           if err == nil && data != nil {
//                // self.db.collection("Posts").document().setData(["url": self.post.ImageURL])
//                print("image upload successfully to storge")
//                print("This is uid:\(self.post.id)")
//                fileRef.downloadURL { downloadUrl, error in
//                    if error == nil {
//                            if let documentId = self.post.id {
//                                print("image upload successfully to store")
//                                self.db.collection("Posts").document(documentId).setData(["url": downloadUrl?.absoluteString as Any])
//                                { error in
//                                    if let error = error {
//                                        print(error.localizedDescription)
//                                    }
//                                }
//
//                            }
//                    }
//                }
//
//
//            }
//       }
//    }
/*
 
 
 
 
 
 ///
 
 
 
 
 
 '///
 
 
 func uploadImageToStorge(image : UIImage?, postId: String){
     print("postId:\(postId)")
     guard image != nil else{
         return
     }
     let storgeRef = Storage.storage().reference()
     let imageDate = image!.jpegData(compressionQuality: 0.2)
     
     guard imageDate != nil else{
         return
     }
     //.jpg
     let path = "images/\(UUID().uuidString)"
     
     let fileRef = storgeRef.child(path)
     let meata = StorageMetadata()
     meata.contentType = "image/jpeg"
     fileRef.putData(imageDate!, metadata: meata) {
         (data, err) in
         
         if err == nil && data != nil {
             self.post.ImageURL = path
             // self.db.collection("Posts").document().setData(["url": self.post.ImageURL])
             print("image upload successfully to storge")
             print("This is uid:\(String(describing: self.post.id))")
             fileRef.downloadURL { downloadUrl, error in
                 if error == nil {
                     //                               if let _ = self.post.id {
                     self.post.ImageURL = downloadUrl!.absoluteString
                     print("This is imageURL :\(String(describing:  self.post.ImageURL))")
                     print("image upload successfully to store")
                     
                     
                     self.db.collection("Posts").getDocuments { doucments, error in
                         if let error = error {
                             print(error.localizedDescription)
                         }
                         guard let doucments = doucments else { return }
                         for douc in doucments.documents {
                             self.db.collection("Posts").document(douc.documentID).setData(["url": downloadUrl?.absoluteString as Any])
                         }
                         
                     }
                     }
                     
                 }
             }
         }
     }
 */
