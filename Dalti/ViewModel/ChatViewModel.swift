//
//  ChatViewModel.swift
//  Dalti
//
//  Created by Sara Alhumidi on 28/07/1444 AH.
//

import SwiftUI
import FirebaseStorage
import Firebase
import Combine
class ChatViewModel : ObservableObject{
    
    @Published var userfb : UserFB = UserFB(id: "", emil: "", password: "")
    @Published var modified = false
    //  @Published  var arr : String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var didCompleteLoginProcess = false
    //= {}
    
//    @State var isLoginMode = false
    
    var image: UIImage?

//    init(didCompleteLoginProcess : {}) {
//        self.didCompleteLoginProcess = ()
//    }
//    init(id : String , emil: String , password: String) {
//        self.userfb.id = userfb.id
//        self.userfb.email = userfb.email
//        self.userfb.password = userfb.password
//    }
//
//     func loginUser() {
//        FirebaseManager.shared.auth.signIn(withEmail: userfb.email, password: userfb.password) { result, err in
//            if let err = err {
//                print("Failed to login user:", err)
//                self.loginStatusMessage = "Failed to login user: \(err)"
//                return
//            }
//            
//            print("Successfully logged in as user: \(result?.user.uid ?? "")")
////            FirebaseManager.shared.currentUser
////            FirebaseManager.shared.firestore(
//            
//            self.loginStatusMessage = "Successfully logged in as user: \(result?.user.uid ?? "")"
//            
//            self.didCompleteLoginProcess.toggle()
//            
//        }
//    }
//    
//    @State var loginStatusMessage = ""
//    
//     func createNewAccount() {
//        if self.image == nil {
//            self.loginStatusMessage = "You must select an avatar image"
//            return
//        }
//        
//        FirebaseManager.shared.auth.createUser(withEmail: userfb.email, password: userfb.password) { result, err in
//            if let err = err {
//                print("Failed to create user:", err)
//                self.loginStatusMessage = "Failed to create user: \(err)"
//                return
//            }
//            print("Successfully created user: \(result?.user.uid ?? "")")
//            self.userfb.id = result?.user.uid ?? "Go to login"
////            self.isLoginMode.toggle()
//            self.loginStatusMessage = "Successfully created user: \(result?.user.uid ?? "")"
//            
//            self.persistImageToStorage()
//        }
//    }
//    
//     func persistImageToStorage() {
//        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
//        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
//        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
//        ref.putData(imageData, metadata: nil) { metadata, err in
//            if let err = err {
//                self.loginStatusMessage = "Failed to push image to Storage: \(err)"
//                return
//            }
//            
//            ref.downloadURL { url, err in
//                if let err = err {
//                    self.loginStatusMessage = "Failed to retrieve downloadURL: \(err)"
//                    return
//                }
//                
//                self.loginStatusMessage = "Successfully stored image with url: \(url?.absoluteString ?? "")"
//                print(url?.absoluteString ?? "")
//                
//                guard let url = url else { return }
//                self.storeUserInformation(imageProfileUrl: url)
//            }
//        }
//    }
//    
//    private func storeUserInformation(imageProfileUrl: URL) {
//        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
//        let userData = [FirebaseConstants.email: self.userfb.email, FirebaseConstants.uid: uid, FirebaseConstants.profileImageUrl: imageProfileUrl.absoluteString]
//        FirebaseManager.shared.firestore.collection(FirebaseConstants.users)
//            .document(uid).setData(userData) { err in
//                if let err = err {
//                    print(err)
//                    self.loginStatusMessage = "\(err)"
//                    return
//                }
//                
//                print("Success")
//                
//                self.didCompleteLoginProcess.toggle()
//            }
//    }
    
}
