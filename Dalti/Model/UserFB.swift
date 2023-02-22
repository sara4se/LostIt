//
//  User.swift
//  Dalti
//
//  Created by Sara Alhumidi on 27/07/1444 AH.
//

import Foundation
 

class UserFB : Identifiable {
    
    var id: String
    var email : String
    var password : String
//    init(id : String , emil: String, password: String) {
//        self.id = id
//        self.email = emil
//        self.password = password
//    }
    init(id : String , emil: String, password: String) {
                self.id = id
                self.email = emil
                self.password = password

    }
}
