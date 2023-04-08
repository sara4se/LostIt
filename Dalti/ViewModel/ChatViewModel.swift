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
 
}
