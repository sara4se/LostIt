//
//  TodayCardView.swift
//  Dalti
//
//  Created by Sara Alhumidi on 25/07/1444 AH.
//

import SwiftUI


struct TodayCardView: View {
    @StateObject var viewModel = PostViewModel()
    
    // Getting Current Scheme Color
    @Environment(\.colorScheme) var color
    var animation: Namespace.ID
    
    var body: some View {
        VStack {
            Image(viewModel.post.ImageURL)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .matchedGeometryEffect(id: "image" + viewModel.post.id!, in: animation)
                .frame(width: UIScreen.main.bounds.width - 30)
            
            HStack {
                Image(viewModel.post.ImageURL)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 65, height: 65)
                    .cornerRadius(15)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(viewModel.post.ItemName)
                        .fontWeight(.bold)
                    
                    Text(viewModel.post.ItemState)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer(minLength: 0)
                
                VStack {
                    Button(action: {}) {
                        Text("GET")
                            .fontWeight(.bold)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 25)
                            .background(Color.primary.opacity(0.1))
                            .clipShape(Capsule())
                    }
                    
                    Text("In App Purchases")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .matchedGeometryEffect(id: "content" + viewModel.post.id!, in: animation)
            .padding()
        }
        .frame(height: 320)
        .background(color == .dark ? Color.black : Color.white)
        .cornerRadius(15)
    }
}
