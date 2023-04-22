//
//  Today.swift
//  Dalti
//
//  Created by Sara Alhumidi on 13/07/1444 AH.
//

import Foundation
import FirebaseFirestoreSwift
import UIKit
struct PostModel : Identifiable,Codable{
    
    @DocumentID var id: String?
    var  ItemName : String
    var ItemState : String
    var Description : String
    var ImageURL : String
    var Phone : String
    var report : String
    var timestamp : Date
}



