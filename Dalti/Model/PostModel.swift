//
//  Today.swift
//  Dalti
//
//  Created by Sara Alhumidi on 13/07/1444 AH.
//

import Foundation
import FirebaseFirestoreSwift
import SwiftUI
struct PostModel : Identifiable,Codable {
    
    @DocumentID var id: String?
    var  ItemName : String
    var ItemState : String
    var Description : String
//
//    enum CodingKeys: String, CodingKey {
//        ////delete up
//        case ItemName
//        case TtemState
//        case Description
//    }
}

struct TodayItem: Identifiable {
    
    var id = UUID().uuidString
    var title: String
    var category: String
    var overlay: String
    var contentImage: String
    var logo: String
}
//delete up
var items = [
    TodayItem(title: "Forza Street", category: "Ultimate Street Racing Game", overlay: "GAME OF THE DAY", contentImage: "b1", logo: "l1"),
    TodayItem(title: "Roblox", category: "Adventure", overlay: "Li Nas X Performs In Roblox", contentImage: "b2", logo: "l2"),
    TodayItem(title: "Roblox", category: "Adventure", overlay: "Li Nas X Performs In Roblox", contentImage: "b2", logo: "l2"),
    TodayItem(title: "Roblox", category: "Adventure", overlay: "Li Nas X Performs In Roblox", contentImage: "b2", logo: "l2"),
]


