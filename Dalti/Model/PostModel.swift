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



