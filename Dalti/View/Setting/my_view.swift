//
//  my_view.swift
//  Dalti
//
//  Created by Sara Alhumidi on 26/08/1444 AH.
//

import SwiftUI

import SwiftUI
import CoreLocation

struct my_view: View {
    let notificationViewModel = NotificationViewModel()

    @ObservedObject var viewModel = LocationViewModel()
    
    var body: some View {
        VStack {
            Text("Current Location: \(viewModel.coordinateString)").padding()
            
        }
        .onAppear {
            print("Initial Location: \(viewModel.coordinateString)")
        }
    }
 
}
struct my_view_Previews: PreviewProvider {
    static var previews: some View {
        my_view()
    }
}

