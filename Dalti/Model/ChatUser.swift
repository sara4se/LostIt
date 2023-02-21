//
//  ChatUser.swift
//  LBTASwiftUIFirebaseChat
//
//  Created by Rawan on 25/07/1444 AH.
//


//struct ChatUser {
//    let uid, email, profileImageUrl: String
//}

import FirebaseFirestoreSwift

struct ChatUser: Codable, Identifiable {
    @DocumentID var id: String?
    let uid, email, profileImageUrl: String
    var TokenDiv : String?
}
