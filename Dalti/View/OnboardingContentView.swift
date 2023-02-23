//
//  OnboardingContentView.swift
//  Dalti
//
//  Created by Sara Alhumidi on 01/08/1444 AH.
//

import SwiftUI


let features = [
    Feature(title: "Inform people around you", subtitle: "Inform about what you lost or found easily and quickly!", image: "Onboarding1"),
    Feature(title: "Navigate in community", subtitle: "View lost and found items that people post it", image: "Onboarding2"),
    Feature(title: "Contact who have your item", subtitle: "Easily and quickly talk with people who found your lost item!", image: "Onboarding3")
]

struct OnboardingContentView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    var feature: Feature
    var showDismissButton: Bool
    var body: some View {
        VStack {
               Spacer()
                Image(feature.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal,16)
                        .frame(width:352 ,height: 326)
                    Text(LocalizedStringKey(feature.title))
                        .font(.custom("SF Pro Display", size: 24))
                        .fontWeight(.semibold)
                        .padding(.top)
                    Text(LocalizedStringKey(feature.subtitle))
                        .font(.custom("SF Pro", size: 20))
                        .fontWeight(.light)
                        .multilineTextAlignment(.center)
                        .padding()
                
                Spacer()
            }
    }
}

struct OnboardingContentView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingContentView(feature: features[0], showDismissButton: true)
    }
}
