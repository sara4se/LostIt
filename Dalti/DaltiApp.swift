//
//  DaltiApp.swift
//  Dalti
//
//  Created by Sara Alhumidi on 10/07/1444 AH.
//

import SwiftUI

@main

struct DaltiApp: App {
    
    @StateObject private var locationManager = LocationManager()
    var body: some Scene {
        WindowGroup {
            Community()
                .environmentObject(locationManager)
        }
    }
}


