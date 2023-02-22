//
//  Post.swift
//  Dalti
//
//  Created by Sara Alhumidi on 10/07/1444 AH.
//

import SwiftUI
import UIKit
import FirebaseStorage
enum Mode {
  case new
  case edit
}
 
enum Action {
  case delete
  case done
  case cancel
}
struct Post: View {
    var post: PostModel
    @Environment(\.presentationMode) private var presentationMode
    @State var presentActionSheet = false
    var mode: Mode = .new
   var completionHandler: ((Result<Action, Error>) -> Void)?
    @State var itemType = ["Lost","Found"]
    @ObservedObject var viewModel = PostViewModel()
//    @ObservedObject var viewModel2 = PostsViewModel()
    @State var Show: Bool = true
    @State var Show2: Bool = false
    @State private var image: UIImage?
    @State private var orderPlaced = false
    @EnvironmentObject private var locationManager: LocationManager
    var body: some View {
      
        NavigationStack{
            ZStack {
                Color("BackGroundColor").ignoresSafeArea()
                  Form{
                            Section{
                                
                                PhotoView(image: $image)
                
                            }header: {
                                HStack{
                                    Text("Select item image:").textCase(nil)
                                        .font(.custom("SF Pro", size: 16))
                                        .foregroundColor(Color("colorOfText"))
                                    Text("(Require)").textCase(nil)
                                        .font(.custom("SF Pro", size: 10))
                                }
                            }
                            
                            Section {
                                
                                Picker("Select item state", selection: $viewModel.post.ItemState) {
                                    ForEach(itemType, id: \.self) {
                                        Text(LocalizedStringKey($0))}
                                   
                                    .font(.custom("SF Pro", size: 16))
                                }.pickerStyle(.navigationLink)
                                if(!viewModel.post.ItemState.isEmpty){
                                    let _ = Show2.toggle()
                                    
                                }
                            }
                            Section{
                                
                                TextField("Add Name", text: $viewModel.post.ItemName)
                                    .font(.custom("SF Pro", size: 16))
                                    .lineSpacing(5)
                            }header: {
                                HStack{
                                    Text("Item name:").textCase(nil)
                                        .font(.custom("SF Pro", size: 16))
                                        .foregroundColor(Color("colorOfText"))
                                    Text("(Require)").textCase(nil)
                                        .font(.custom("SF Pro", size: 10))
                                }
                           }
                            Section{
                                
                                TextEditorWithPlaceholder(text: $viewModel.post.Description)
                                    .font(.custom("SF Pro", size: 16))
                                    .frame(width: 355 , height: 104)
                                    .padding(.top, 20)
                                    .padding(.leading,20)
                                
                            } header: {
                                HStack{
                                    Text("Description:").textCase(nil)
                                        .font(.custom("SF Pro", size: 16))
                                        .foregroundColor(Color("colorOfText"))
                                    Text("(Optional)").textCase(nil)
                                        .font(.custom("SF Pro", size: 10))
                                }
                            }
                            
                            Section{
                                TextField("Add phone number", text: $viewModel.post.Phone)
                                    .font(.custom("SF Pro", size: 16))
                                    .lineSpacing(5)
                                Toggle(
                                    isOn: $Show,
                                    label:{
                                        Text("Show phone number ")
                                            .font(.custom("SF Pro", size: 16))
                                        
                                    })
                            }header: {
                                HStack{
                                    Text("Phone number:").textCase(nil)
                                        .font(.custom("SF Pro", size: 16))
                                        .foregroundColor(Color("colorOfText"))
                                }
                            }
                            
                        footer:{
//                            Button(action: placeOrder) {
//                                Text("Place Order:")
//                                    .foregroundColor(.white)
//                                    .font(.headline)
//                                    .frame(width: 300 , height: 53)
//                                    .background(Color(("Mygray")))
//                                    .cornerRadius(8)
//                            }
//
                            
                            Button {
                                handleDoneTapped()
                            } label: {
                                
                                if(!viewModel.post.ItemState.isEmpty && !viewModel.post.ItemName.isEmpty){
                                    Text("Post")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                        .frame(width: 300 , height: 53)
                                        .background(Color(("Mygreen")))
                                        .cornerRadius(8)
                                        .shadow(radius: 3)
                                }else{
                                    Text("Post")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                        .frame(width: 300 , height: 53)
                                        .background(Color(("Mygray")))
                                        .cornerRadius(8)
                                        .shadow(radius: 3)
                                }
                            }.disabled(viewModel.post.ItemState.isEmpty || viewModel.post.ItemName.isEmpty)
                                .padding(.all)
                                .disabled(!viewModel.modified)
                        }
                            //
                        }.pickerStyle(.inline)
                          
                    }
                    .alert(isPresented: $orderPlaced) {
                        Alert(
                            title: Text("Post Upload"),
                            message:
                                Text("Do you like to be notified when Your item been found?"),
                            primaryButton: .default(Text("Yes")) {
                                requestNotification()
                            },
                            secondaryButton: .default(Text("No"))
                        )
                    }
             
            }
            .navigationBarTitle("Post", displayMode: .large)
        }
        
    func handleCancelTapped() {
        self.dismiss()
    }
    func requestNotification() {
      locationManager.validateLocationAuthorizationStatus()
    }
    
    func handleDoneTapped() {
      //  self.viewModel.handleDoneTapped()
        self.viewModel.uploadImageToStorge(uuimage: image, ItemName: viewModel.post.ItemName, ItemState: viewModel.post.ItemState, Description: viewModel.post.Description,Phone: viewModel.post.Phone)
        self.dismiss()
    }
    
    func handleDeleteTapped() {
        viewModel.handleDeleteTapped()
        self.dismiss()
        self.completionHandler?(.success(.delete))
    }
    func placeOrder() {
      orderPlaced = true
    }
    func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
    }


struct Post_Previews: PreviewProvider {
    
    static var previews: some View {
        Post(post: .init(ItemName: "", ItemState: "", Description: "", ImageURL: "" , Phone: ""))
    }
}

extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}

extension UIImage {
    func toPngString() -> String? {
        let data = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
  
    func toJpegString(compressionQuality cq: CGFloat) -> String? {
        let data = self.jpegData(compressionQuality: cq)
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}
 


struct TextEditorWithPlaceholder: View {
        @Binding var text: String
        
        var body: some View {
            ZStack(alignment: .leading) {

                if text.isEmpty {
                   VStack {
                        Text("Item color, location...")
                           .font(.custom("SF Pro", size: 16))
                           .foregroundColor(.gray)
                            .padding(.top, 10)
                            .padding(.leading, 10)
                            .opacity(0.6)
                            
                        Spacer()
                    }
                }
                
                VStack {
                    TextEditor(text: $text)
                        .frame(minHeight: 150, maxHeight: 300)
                        .opacity(text.isEmpty ? 0.85 : 1)
                    Spacer()
                }
            }
        }
    }



let placeHolderImage = UIImage()
