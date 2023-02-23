//
//  Chat.swift
//  Dalti
//
//  Created by Sara Alhumidi on 10/07/1444 AH.
//

import SwiftUI
import FirebaseStorage
import Firebase


struct Chat: View {
    
    let didCompleteLoginProcess: () -> ()
//
    @State private var isLoginMode = false
//    @State private var email = ""
//    @State private var password = ""
    @ObservedObject var viewModelChat : ChatViewModel = ChatViewModel()
   // @Binding var Show: Bool
//    @State var image: UIImage?
    @State private var shouldShowImagePicker = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Picker(selection: $isLoginMode, label: Text("Picker here")) {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    if !isLoginMode {
                        Button {
                            shouldShowImagePicker.toggle()
                        } label: {
                            
                            VStack {
                                if let image = self.viewModelChat.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 128, height: 128)
                                        .cornerRadius(64)
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 64))
                                        .padding()
                                        .foregroundColor(Color(.label))
                                }
                            }
                            .overlay(RoundedRectangle(cornerRadius: 64)
                                .stroke(Color.black, lineWidth: 3)
                            )
                            
                        }
                    }
                    
                    Group {
                        TextField("Email", text: $viewModelChat.userfb.email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        SecureField("Password", text: $viewModelChat.userfb.password)
                    }
                    .padding(12)
                    .background(Color.white)
                    Button {
                        handleAction()
                    } label: {
                        Text(isLoginMode ? "Log In" : "Create Account")
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(width: 300 , height: 53)
                            .background(Color(("Mygreen")))
                            .cornerRadius(8)
                            .shadow(radius: 3)
                    }
                   
//                    Text(String(self.viewModelChat.$isLoginMode)).foregroundColor(.red)
                 let _ = print(self.$isLoginMode)
//                    Text(self.loginStatusMessage)
//                        .foregroundColor(.red)
                    let _ = print(self.loginStatusMessage)
                }
                .padding()
                
            }
            .navigationTitle(isLoginMode ? "Log In" : "Create Account")
            .background(Color(.init(white: 0, alpha: 0.05))
                .ignoresSafeArea())
        }
        
         .navigationBarTitle("Chat", displayMode: .large)
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker2(image: $viewModelChat.image)
                .ignoresSafeArea()
        }
    }
    
    
    func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: viewModelChat.userfb.email, password: viewModelChat.userfb.password) { result, err in
           if let err = err {
               print("Failed to login user:", err)
//               switch error.code {
             //               case AuthErrorCode.wrongPassword.rawValue:
             //                        print("wrong password, you big dummy")
             //                   self.loginStatusMessage = "wrong password, you big dummy"
             //                    case AuthErrorCode.invalidEmail.rawValue:
             //                        print("invalid email - duh")
             //                    case AuthErrorCode.accountExistsWithDifferentCredential.rawValue:
             //                        print("the account already exists")
             //                    default:
             //                        print("unknown error: \(err.localizedDescription)")
             //                    }
               self.loginStatusMessage = "Failed to login user"
               return
           }
           
           print("Successfully logged in as user: \(result?.user.uid ?? "")")
//            FirebaseManager.shared.currentUser
//            FirebaseManager.shared.firestore(
           
           self.loginStatusMessage = "Successfully logged in as user"
           
           self.didCompleteLoginProcess()
           
       }
   }
   
   @State var loginStatusMessage = ""
   
    func createNewAccount() {
        if self.viewModelChat.image == nil {
           self.loginStatusMessage = "You must select an avatar image"
           return
       }
       
        FirebaseManager.shared.auth.createUser(withEmail: viewModelChat.userfb.email, password: viewModelChat.userfb.password) { result, err in
           if let err = err {
               print("Failed to create user:", err)
               self.loginStatusMessage = "Failed to create user"
               return
           }
           print("Successfully created user: \(result?.user.uid ?? "")")
          //  self.viewModelChat.userfb.id = result?.user.uid ?? "Go to login"
//            self.isLoginMode.toggle()
           self.loginStatusMessage = "Successfully created user"
           
           self.persistImageToStorage()
       }
   }
   
    func persistImageToStorage() {
       guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
       let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = self.viewModelChat.image?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, err in
           if let err = err {
               self.loginStatusMessage = "Failed to push image to Storage"
               return
           }
           
           ref.downloadURL { url, err in
               if let err = err {
                   self.loginStatusMessage = "Failed to retrieve downloadURL"
                   return
               }
               
               self.loginStatusMessage = "Successfully stored image with url"
               print(url?.absoluteString ?? "")
               
               guard let url = url else { return }
               self.storeUserInformation(imageProfileUrl: url)
               self.didCompleteLoginProcess()
           }
       }
   }
   
   private func storeUserInformation(imageProfileUrl: URL) {
       guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
       let userData = [FirebaseConstants.email: self.viewModelChat.userfb.email, FirebaseConstants.uid: uid, FirebaseConstants.profileImageUrl: imageProfileUrl.absoluteString]
       FirebaseManager.shared.firestore.collection("Community")
           .document("Users").collection(FirebaseConstants.users)
           .document(uid).setData(userData) { err in
               if let err = err {
                   print(err)
                  // self.loginStatusMessage = "\(err)"
                   return
               }
               
               print("Success")
               
               self.didCompleteLoginProcess()
           }
   }
    private func handleAction() {
        if isLoginMode {
                        print("Should log into Firebase with existing credentials",isLoginMode)
//            loginUser()
             loginUser()
         
        } else {
             createNewAccount()
            print("Register a new account inside of Firebase Auth and then store image in Storage somehow....",isLoginMode)
           // isLoginMode.toggle()
            self.didCompleteLoginProcess()
                     
        }
    }

}
struct Chat_Previews: PreviewProvider {
    static var previews: some View {
//        .constant(
//        Chat(didCompleteLoginProcess: () , viewModelChat: ChatViewModel())
//        Chat(viewModelChat: ChatViewModel(didCompleteLoginProcess))
        Chat(didCompleteLoginProcess: {}, viewModelChat: ChatViewModel())
        
       // Post(post: .init(ItemName: "", ItemState: "", Description: "", ImageURL: ""))
    }
}

struct ImagePicker2: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    
    private let controller = UIImagePickerController()
    
    func makeCoordinator() -> Coordinator2 {
        return Coordinator2(parent: self)
    }
    
    class Coordinator2: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        let parent: ImagePicker2
        
        init(parent: ImagePicker2) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            parent.image = info[.originalImage] as? UIImage
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }

        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
}
