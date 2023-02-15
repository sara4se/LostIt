//
//  Splash.swift
//  Dalti
//
//  Created by Sara Alhumidi on 10/07/1444 AH.
//

import SwiftUI

//
//    @EnvironmentObject private var launchScreenState: LaunchScreenStateManager
//
    struct Splash: View {
      
      @State var animation: Bool = false
      @State var showSplash: Bool = true
      
        
    var body: some View {
        VStack{
          ZStack{
              ZStack{
//                Color(color)
                
                Image("LOGO")
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .frame(width: 200, height: 200, alignment: .center)
                  .scaleEffect(animation ? 50 : 1)
                  .animation(Animation.easeOut(duration: 0.4))
                
                
              }
              .edgesIgnoringSafeArea(.all)
              .animation(Animation.linear(duration: 1))
              .opacity(showSplash ? 1 : 0)
            }
          }.onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
              self.animation.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
              self.showSplash.toggle()
            }
          })
          
          
        }
      }
//        VStack {
//            Image("LOGO")
//                .resizable()
//                .scaledToFit()
//                .foregroundColor(.accentColor)
//                .frame(width: 300, height: 300)
////            Text("نلقاها").font(.custom("Aref Ruqaa", size: 50))
////                .foregroundColor(Color("babyGren"))
//
//        }
//        .padding()
//        .task {
//            try? await getDataFromApi()
//            try? await Task.sleep(for: Duration.seconds(3))
//            self.launchScreenState.dismiss()
//        }
//    }
//
//    fileprivate func getDataFromApi() async throws {
//        let googleURL = URL(string: "https://www.google.com")!
//        let (_,response) = try await URLSession.shared.data(from: googleURL)
//        print(response as? HTTPURLResponse)
//    }
//}

struct Splash_Previews: PreviewProvider {
    static var previews: some View {
        Splash()
            .environmentObject(LaunchScreenStateManager())
    }
}
