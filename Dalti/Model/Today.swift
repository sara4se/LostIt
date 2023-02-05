//
//  Today.swift
//  Dalti
//
//  Created by Sara Alhumidi on 13/07/1444 AH.
//

import Foundation


struct TodayItem: Identifiable {
    
    var id = UUID().uuidString
    var title: String
    var category: String
    var overlay: String
    var contentImage: String
    var logo: String
}

var items = [
    TodayItem(title: "Forza Street", category: "Ultimate Street Racing Game", overlay: "GAME OF THE DAY", contentImage: "b1", logo: "l1"),
    TodayItem(title: "Roblox", category: "Adventure", overlay: "Li Nas X Performs In Roblox", contentImage: "b2", logo: "l2"),
    TodayItem(title: "Roblox", category: "Adventure", overlay: "Li Nas X Performs In Roblox", contentImage: "b2", logo: "l2"),
    TodayItem(title: "Roblox", category: "Adventure", overlay: "Li Nas X Performs In Roblox", contentImage: "b2", logo: "l2"),
]


