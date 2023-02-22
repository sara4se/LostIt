//
//  Profile.swift
//  Dalti
//
//  Created by Sara Alhumidi on 10/07/1444 AH.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import SDWebImageSwiftUI
struct Profile: View {
 
    @State private var phoneNumber = "+966 597223332"
 
    @ObservedObject private var vm = MainMessagesViewModel()
    @State var splashScreen  = true
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var profileImage: Image?
    @State private var avatarImage = UIImage(named: "image2")!
    @StateObject var viewModelChat : ChatViewModel = ChatViewModel()
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
//                    RoundedRectangle(cornerRadius: 25, style: .continuous)
//                        .fill(Color("BackGroundColor"))
//                        .shadow(radius: 1)
//                        .frame(width: 350, height: 146).padding(20)
                    
                   HStack(spacing: 20){
                        VStack {
                            ZStack {
                                WebImage(url: URL(string: vm.chatUser?.profileImageUrl ?? ""))
                                    .resizable()
                                    .scaledToFill()
                                if (vm.chatUser?.profileImageUrl == nil){
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .foregroundColor(Color(.label))
                                        .frame(width: 80, height: 90)
                                 }
                            }
                        }.frame(width: 100, height: 100)
                            .clipped()
                            .cornerRadius(50)
//                            .overlay(RoundedRectangle(cornerRadius: 44)
//                            .stroke(Color(.label), lineWidth: 1)
//                        )
                        .shadow(radius: 5)
                      
                        VStack {
                            HStack{
                                
                                let email = vm.chatUser?.email.replacingOccurrences(of: "@gmail.com", with: "") ?? ""
                                Text("Name ")
                                    .font(.system(size: 24, weight: .regular))
                                    .foregroundColor(Color("colorOfText"))
                                Text(email)
                                    .font(.system(size: 24, weight: .regular))
                                    .foregroundColor(Color("colorOfText"))
                            }
                        }.padding(.trailing,90)
                    }.padding() //Hstack
               } //Zstack
                Spacer()
                ZStack {

                    VStack (spacing: -20) {
                        Text("Scan to contact")
                            .offset(x:-90)
                            .padding(30)
                        let email = vm.chatUser?.email.replacingOccurrences(of: "@gmail.com", with: "@gmail.com") ?? ""
                        Image(uiImage: gererateQRCode(from: "\(email)"))
                            .resizable()
                            .interpolation(.none) // make it clearer
                            .scaledToFit()
                            .frame(width: 450, height: 300)
                    }
                }// End Vstack
               
                .navigationBarTitle("Profile", displayMode: .large)
            }
        }
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
        Profile(viewModelChat: ChatViewModel())
    }
}
