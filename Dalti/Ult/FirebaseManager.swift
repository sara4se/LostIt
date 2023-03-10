//
//  FirebaseManager.swift
//  Dalti
//
//  Created by Rawan on 24/07/1444 AH.
//

import Firebase
import Foundation
import FirebaseStorage
import FirebaseAuth
class FirebaseManager: NSObject {
    
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    
    var currentUser: ChatUser?
    
    static let shared = FirebaseManager()
   
    
    override init() {
      //  FirebaseApp.configure()

        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()

        super.init()
    }
    
}
