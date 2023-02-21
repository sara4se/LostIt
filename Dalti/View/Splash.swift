//
//  Splash.swift
//  Dalti
//
//  Created by Sara Alhumidi on 10/07/1444 AH.
//



import SwiftUI
struct Splash: View {
    init(){
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.init(Color(.black))]
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .black
                
            }
    @State private var isActive :Bool = false
    @State var animation: Bool = false
    @State private var revolving = false
    @StateObject private var locationManager = LocationManager()
       var body: some View {
           ZStack{
//               Color("BackGroundColor").ignoresSafeArea()
                          
               if self.isActive{
                  
                       Community().environmentObject(locationManager)
                   
               }
               else{
                   ZStack {
                       VStack {
                           
                           Image("LOGO")
                               .resizable()
                               .aspectRatio(contentMode: .fit)
                               .frame(width: 200, height: 200, alignment: .center)
                              
                           //                           Text("ضالتي / قريب / تلقاه، نلقاه، لقيته..الخ ")
                           //                           Text("LOSTET")
                           Text("Findet")
                               .foregroundColor(Color("lightGreen"))
                               .font(.custom("SF Pro", size: 22))
                               
                           //                               .offset(x: 10, y: -20)
                       }
//                       .scaleEffect(animation ? 2 : 1)
//                       //.animation(Animation.easeInOut(duration: 1))
//                           .animation(.easeInOut(duration: 1), value: animation)
//                           .padding(40)
                       //   .animation(.easeOut(duration: 0.4), value: showSplash)
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



//
//ZStack {
//    Image("LOGO1")
//        .resizable()
//        .aspectRatio(contentMode: .fit)
//        .frame(width: 100, height: 100, alignment: .center)
//        .scaleEffect(animation ? 2 : 1)
//    //.animation(Animation.easeInOut(duration: 1))
//
//        .padding(40)
//    Image(systemName: "mappin")
//        .resizable()
//        .foregroundColor(.gray)
//      .aspectRatio(contentMode: .fit)
//     .frame(width: 100, height: 20)
//        .scaleEffect(animation ? 2 : 1)
//    //.animation(Animation.easeInOut(duration: 1))
//     //   .animation(.easeInOut(duration: 1), value: animation)
//      //  .padding(40)
//
//        .rotationEffect(.degrees(revolving ? 30 : -30))
//    //.rotation3DEffect(.degrees(15), axis: (x: 3, y: 1, z: 0))
//        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: false), value: revolving)
//        .onAppear {
//            revolving.toggle()
//        }}
////                           Text("ضالتي / قريب / تلقاه، نلقاه، لقيته..الخ ")
////                           Text("LOSTET")
//Text("App Name")
//    .foregroundColor(Color("lightGreen"))
//    .font(.custom("SF Pro", size: 13))
//    .scaleEffect(animation ? 2 : 1)
//    .animation(.easeInOut(duration: 1), value: animation)
//   // .rotationEffect(.degrees(revolving ? -360 : 360))
////                               .offset(x: 10, y: -20)
//}
////   .animation(.easeOut(duration: 0.4), value: showSplash)
