//
//  ChatMesage.swift
//  LBTASwiftUIFirebaseChat
//
//  Created by Rawan on 26/07/1444 AH.
//

//import Foundation
//
import Foundation
import FirebaseFirestoreSwift

struct ChatMessage: Codable, Identifiable {
    @DocumentID var id: String?
    let fromId, toId, text: String
    let timestamp: Date
}


//struct ChatMessage: Identifiable {
//
//    var id: String { documentId }
//
//    let documentId: String
//    let fromId, toId, text: String
//
//    init(documentId: String, data: [String: Any]) {
//        self.documentId = documentId
//        self.fromId = data[FirebaseConstants.fromId] as? String ?? ""
//        self.toId = data[FirebaseConstants.toId] as? String ?? ""
//        self.text = data[FirebaseConstants.text] as? String ?? ""
//    }
//}
