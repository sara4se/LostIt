//
//  OnboardingContainerView.swift
//  Dalti
//
//  Created by Sara Alhumidi on 01/08/1444 AH.
//

import SwiftUI

struct OnboardingContainerView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
//    @Environment(\.presentationMode) private var presentationMode
    @State var isClick : Bool = false
    var body: some View {
        NavigationStack{
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
                    //              NavigationLink("", destination: Splash())
                    //  self.presentationMode.wrappedValue.dismiss()
                    isClick.toggle()
                    isOnboarding = false
                } label: {
                    Text("Start Using Findit")
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(width: 300 , height: 53)
                        .background(Color(("Mygreen")))
                        .cornerRadius(8)
                        .shadow(radius: 3)
                }.navigationBarBackButtonHidden()
                NavigationLink("", isActive: $isClick) {
                    Splash()
                }
            }
        }}
    
 
}

struct OnboardingContainerView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingContainerView()
    }
}
