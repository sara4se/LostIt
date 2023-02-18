//
//  Profile.swift
//  Dalti
//
//  Created by Sara Alhumidi on 10/07/1444 AH.
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
                VStack (spacing: 20) {
             Spacer()
                }
                    .toolbar{
                    NavigationLink(destination: settingsPage(), label:{
                        Label("Settings", systemImage: "gear")
                            .foregroundColor(Color("lightGreen"))
                    })
                }
               ZStack {
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(Color("BackGroundColor"))
                        .shadow(radius: 1)
                        .frame(width: 400, height: 146)
                    
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
                            TextField("Name", text: $name)
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
                    }.padding() //Hstack
               } //Zstack
                Spacer()
                ZStack {

                    VStack (spacing: -20) {
                        Text("Scan to contact")
                            .offset(x:-90)
                            .padding(30)
                        Image(uiImage: gererateQRCode(from: "\(phoneNumber)"))
                            .resizable()
                            .interpolation(.none) // make it clearer
                            .scaledToFit()
                            .frame(width: 450, height: 300)
                    }
                }// End Vstack
               
                .navigationBarTitle("Profile", displayMode: .large)
                .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
                    ImagePicker(selectedImage: $selectedImage, avatarImage: $avatarImage)
                }
            }.background(Color("BackGroundColor"))
//            Spacer()
        }
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
    
    
    
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                Text("Profile Page")
//
//            }
//                .toolbar{
//                            NavigationLink(destination: Chat(), label:{
//                    Label("Chat", systemImage: "message")
//                        .foregroundColor(.black)
//                })
//
//                NavigationLink(destination: Post(post: PostModel.init(ItemName: "", ItemState: "", Description: "", ImageURL: "")), label:{
//                    Label("Post", systemImage: "plus")
//                        .foregroundColor(.black)
//                })
//
//
//            }
//            .navigationBarTitle("Profile", displayMode: .large)
//        }.background(Color("BackGroundColor"))
//
//    }
//}
//
//struct Profile_Previews: PreviewProvider {
//    static var previews: some View {
//        Profile()
//    }
//}
