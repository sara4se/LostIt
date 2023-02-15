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
    
    
    //    init(id: String? = nil, ItemName: String, ItemState: String, Description: String, ImageURL: UIImage? = nil) {
    //        self.id = id
    //        self.ItemName = ItemName
    //        self.ItemState = ItemState
    //        self.Description = Description
    //        self.ImageURL = ImageURL
    //    }
    //    required init(from decoder:Decoder) throws {
    //           let values = try decoder.container(keyedBy: CodingKeys.self)
    //        ItemName = try values.decode(String.self, forKey: .ItemName)
    //        ItemState = try values.decode(String.self, forKey: .ItemState)
    //        Description = try values.decode(String.self, forKey: .Description)
    //        ImageURL = try values.decode(UIImage?.self, forKey: .ImageURL)
    //       }
    //    private enum CodingKeys: String, CodingKey {
    //
    //        case id
    //        case  ItemName
    //        case ItemState
    //        case Description
    //        case ImageURL
    //    }
    
}

=======
struct PostModel : Identifiable,Codable{
    @DocumentID var id: String?
    //    var id = UUID().uuidString
    ////delete up
    var  ItemName : String
    var TtemState : String
    var Description : String
    
    enum CodingKeys: String, CodingKey {
        ////delete up
        case ItemName
        case TtemState
        case Description
    }
}

struct TodayItem: Identifiable {
    
    var id = UUID().uuidString
    var title: String
    var category: String
    var overlay: String
    var contentImage: String
    var logo: String
}
////delete up
var items = [
    TodayItem(title: "Forza Street", category: "Ultimate Street Racing Game", overlay: "GAME OF THE DAY", contentImage: "b1", logo: "l1"),
    TodayItem(title: "Roblox", category: "Adventure", overlay: "Li Nas X Performs In Roblox", contentImage: "b2", logo: "l2"),
    TodayItem(title: "Roblox", category: "Adventure", overlay: "Li Nas X Performs In Roblox", contentImage: "b2", logo: "l2"),
    TodayItem(title: "Roblox", category: "Adventure", overlay: "Li Nas X Performs In Roblox", contentImage: "b2", logo: "l2"),
]



