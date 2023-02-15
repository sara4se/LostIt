//
//  Profile.swift
//  Dalti
//
//  Created by Sara Alhumidi on 10/07/1444 AH.
//
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins


struct Profile: View {
    
    
    @State private var name = "Mashael Alharbi"
    @State private var phoneNumber = "+966 597223332"
    
    @State var splashScreen  = true
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var profileImage: Image?
    @State private var avatarImage = UIImage(named: "image2")!
    
//    @AppStorage("name") var name = DefaultSettings.name
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    //    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                VStack (spacing: 10) {
                    Text("User Information")
                        .offset(x:-110)
                } .toolbar{
                    NavigationLink(destination: settingsPage(), label:{
                        Label("Settings", systemImage: "gear")
                            .foregroundColor(.black)
                    })
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(.white)
                        .shadow(radius: 1)
                        .frame(width: 355, height: 146)
                    
                    HStack (spacing: 40) {
                        VStack {
                            Image(uiImage: avatarImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .padding()
                                .offset(x:30)
                            
                                .onTapGesture {
                                    showImagePicker = true
                                }
                        }
                        VStack {
                            TextField("Name" , text: $name)
                                .textContentType(.name)
                                .font(.system(size: 18))
                            Divider()
                                .padding(.trailing/*@END_MENU_TOKEN@*/)
                                .frame(width: 215, height: 1.0)
                                .offset(x:-10)
                            
                             TextField("Phone Number" , text: $phoneNumber)
                                .textContentType(.telephoneNumber)
                                .font(.system(size: 18))
                        }
                    } //Hstack
                } //Zstack
                
                ZStack {
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(.white)
                        .shadow(radius: 1)
                        .frame(width: 355, height: 370)
                    
                    VStack (spacing: -20) {
                        Text("Your Code")
                            .offset(x:-130)
                        
                        Image(uiImage: gererateQRCode(from: "\(name)"))
                            .resizable()
                            .interpolation(.none) // make it clearer
                            .scaledToFit()
                            .frame(width: 355, height: 434)
                    }
                }// End Vstack
                
                //   VStack(spacing: 15) {
//                     VStack(spacing: 5) {
//                           Text(name)
//                           .bold()
//                           .font(.system)
//                                        }
                // End Vstack
                
//                if let selectedImage = selectedImage {
//                    Button {
//                        print("DEBUD: Finish registering user..")
//                        //                    viewModel.uploadProfileImage(selectedImage)
//                    } label: {
//                        Text("Continue")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .frame(width: 340, height: 50)
//                            .background(Color("babyGren"))
//                            .clipShape(Capsule())
//                            .padding()
//                    }
//                    .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 0)
//                }
            }
            
            // End Hstack
//            .ignoresSafeArea()
//            .navigationBarHidden(true)
            
            
            .navigationBarTitle("Profile", displayMode: .large)
            .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
                ImagePicker(selectedImage: $selectedImage, avatarImage: $avatarImage)
            }
        }
        // End Zstack
        //.modifier(ProfileImageModifier())
      
        Spacer()
        
        
      
          
    }
    
    
    func loadImage() {
        guard let selectedImage = selectedImage else { return }
        profileImage = Image(uiImage: selectedImage)
    }

 func gererateQRCode(from string: String) -> UIImage {
    filter.message = Data(string.utf8)
    
    if let outputImage = filter.outputImage {
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgimg)
        }
    }
    
    return UIImage(systemName: "xmark.circle") ?? UIImage()
}
}
struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
