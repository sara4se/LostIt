//
//  Splash.swift
//  Dalti
//
//  Created by Sara Alhumidi on 10/07/1444 AH.
//


import SwiftUI
struct Splash: View {
 
    @State private var isActive :Bool = false
    @State var animation: Bool = false
    @State private var drawingWidth = false
   // @Binding var Show: Bool
    @State private var revolving = false
    @StateObject private var locationManager = LocationManager()
       var body: some View {
           ZStack{
//               Color("BackGroundColor").ignoresSafeArea()
                          
               if self.isActive{
                   withAnimation(.easeInOut) {
                       Community().environmentObject(locationManager)
                   }
               }
               else{
                   ZStack {
                       VStack{
                           VStack {
                               Image("LOGO")
                                   .resizable()
                                   .aspectRatio(contentMode: .fit)
                                   .frame(width: 200, height: 200, alignment: .center)
                               
                               //                           Text("ضالتي / قريب / تلقاه، نلقاه، لقيته..الخ ")
                               //                           Text("LOSTET")
                               
                               Text("Findet")
                                   .foregroundColor(Color("lightGreen"))
                                   .font(.custom("SF Pro", size: 40))
                               HStack {
                                   DotView() // 1.
                                   DotView(delay: 0.2) // 2.
                                   DotView(delay: 0.4) // 3.
                                   
                               }
                               //                               .offset(x: 10, y: -20)
                           }
//                           .scaleEffect(animation ? 2 : 1)
//                           //.animation(Animation.easeInOut(duration: 1))
//                           .animation(.easeInOut(duration: 1), value: animation)
//                           .padding(40)
//                           .animation(.easeOut(duration: 0.4), value: animation)
                       }
                   }
               }
            
           }
           .onAppear {
               DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                     self.animation.toggle()
           }
               DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                  
                       isActive = true
                       

               }
           }
       }
   }

   struct Splash_Previews: PreviewProvider {
       static var previews: some View {
           Splash()
       }
   }

////   .animation(.easeOut(duration: 0.4), value: showSplash)

