//
//  OnboardingContainerView.swift
//  Dalti
//
//  Created by Sara Alhumidi on 01/08/1444 AH.
//

import SwiftUI

struct OnboardingContainerView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
  
    var body: some View {
        VStack {
            HStack{
                Spacer()
                Button(action: { isOnboarding = false }, label: {
                    Text("Skip")
                        .font(.custom("SF Pro Display", size: 20))
                        .fontWeight(.regular)
                        .foregroundColor(Color("colorOfText"))
                }).padding(.trailing)
                
           
            }
            TabView {
                
                ForEach(features) { feature in
                    OnboardingContentView(feature: feature, showDismissButton: false)
                }
            }
            
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode:.always))
            Button {
                helo()
            } label: {
                Text("Start Using Findet")
                    .foregroundColor(.white)
                    .font(.headline)
                    .frame(width: 300 , height: 53)
                    .background(Color(("Mygreen")))
                    .cornerRadius(8)
                    .shadow(radius: 3)
            }
        }
        
        
     
    }
    func helo() {
        Link(destination: URL(string: "https://daltyy.blogspot.com/2023/02/nalqaha.html")!, label: { Label("Privacy Policy", systemImage: "arrow.up.forward").font(.system(size: 20))
                .bold()
                .foregroundColor(.white)
                .font(.headline)
                .frame(width: 300 , height: 53)
                .background(Color(("Mygreen")))
                .cornerRadius(8)
            
        }
    )
    }
}

struct OnboardingContainerView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingContainerView()
    }
}
