//
//  File.swift
//  Dalti
//
//  Created by Sara Alhumidi on 22/07/1444 AH.
//

import Foundation
import FirebaseStorage
import SwiftUI

class FBViewModel: ObservableObject{
    
    @Published var postToFB : PostModel
    
    
    init(postToFB: PostModel = PostModel(ItemName: "", ItemState: "", Description: "", ImageURL: "")) {
        self.postToFB = postToFB
    }
}
