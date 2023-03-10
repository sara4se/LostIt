//
//  Privacy Policy.swift
//  Dalti
//
//  Created by Mashael Alharbi on 13/02/2023.
//

import SwiftUI

struct Privacy_Policy: View {
    var body: some View {
        
        NavigationStack {
            ScrollView {
 
                VStack{
                    Text("Pleas click bellow to read the privacy policy page on the web")
                        .font(.custom("SF Pro", size: 22))
                        .fontWeight(.semibold)
                        .fontWeight(.bold)
                        .foregroundColor(Color("colorOfText"))
                        .frame(width: 350, height: 100).padding(10)
                    Link(destination: URL(string: "https://daltyy.blogspot.com/2023/02/nalqaha.html")!, label: { Label("Privacy Policy", systemImage: "arrow.up.forward").font(.system(size: 20))
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(width: 300 , height: 53)
                            .background(Color(("Mygreen")))
                            .cornerRadius(8)
                            .shadow(radius: 3)
                        
                    }
                )
                }.frame(width: 500,height: 400).padding(20)
                    .navigationBarTitle("Privacy Policy", displayMode: .large)
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
