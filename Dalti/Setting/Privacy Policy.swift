//
//  Privacy Policy.swift
//  Dalti
//
//  Created by Mashael Alharbi on 13/02/2023.
//

import SwiftUI

struct Privacy_Policy: View {
    var body: some View {
        
        NavigationView {
            ScrollView {
                ZStack {
                    
                    Image("LOGO")
                        .resizable()
                        .opacity(0.3)
                    //  .aspectRatio(contentMode: .fill)
                        .offset(y:50)
                        .frame(width:200, height:200)
                    //                     .padding()
                }
                
             
                VStack{
                    Link(destination: URL(string: "https://daltyy.blogspot.com/2023/02/nalqaha.html")!, label: { Label("Press Here To Read ", systemImage: "")})
                        .font(.system(size: 20))
                        .bold()
//                        .offset(y:200)
                        .padding(20)
                        .foregroundColor(.white)
                        .background(Color("babyGren"))
                        .cornerRadius(6)
                }
            
                .offset(y:80)
              
                .navigationTitle("Our Privacy Policys")
                .font(.caption)
                .accentColor(.black)
                .ignoresSafeArea()
            }
        }
    }
}

struct Privacy_Policy_Previews: PreviewProvider {
    static var previews: some View {
        Privacy_Policy()
    }
}
