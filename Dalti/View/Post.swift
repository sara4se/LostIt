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

=======
    var post: PostModel

    var body: some View {
        NavigationStack{
            ZStack {
                Color.gray.opacity(0.1)
                .ignoresSafeArea()
                VStack{
                
                    Dalti.ItemType()
                    
    
                }
             
            }
            .navigationBarTitle("Post", displayMode: .large)
        }
        
        
    }
}

struct Post_Previews: PreviewProvider {
    
    static var previews: some View {
        Post(post: .init(ItemName: "", ItemState: "", Description: "", ImageURL: ""))
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
struct ItemType: View {

    @State var itemType = ["Select","Lost","Found"]
    @State var  ItemType = ""
    @State var Title : String = ""
    @State var fullText: String = ""
    @State var Show: Bool = true
    @State var Show2: Bool = false
    @FocusState private var amountIsFocused: Bool
=======
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
//    @State private var UrlForImage: URL?

    var body: some View {
        ZStack {
            Form{
                Section{


                    AddPhoto()}header: {
                        HStack{
                            Text("Item Image:")
                                .textCase(nil)
                                .font(.custom("SF Pro", size: 16))
                                .foregroundColor(.black)
                          
                                Text("(Optional)")
                                .textCase(nil)
                                .font(.custom("SF Pro", size: 12))
                        }
=======
                    
                    AddPhoto(image: $image)
    
                }header: {
                    HStack{
                        Text("Item Image:")
                            .font(.custom("SF Pro", size: 16))
                            .foregroundColor(.black)
                        
                        Text("(OPTIONAL)")
                            .font(.custom("SF Pro", size: 12))

                    }
                }
                
                Section {
                    Picker("Select the item state", selection: $viewModel.post.ItemState) {
                        ForEach(itemType, id: \.self) {
                            Text($0)}
                        .font(.custom("SF Pro", size: 16))
                        if(!viewModel.post.ItemState.isEmpty){
                            let _ = Show2.toggle()
                            
                        }
                    }.pickerStyle(.navigationLink)
                }
                Section{


                    TextField("Add Name", text: $Title)
                        .focused($amountIsFocused)
                        .font(.custom("SF Pro", size: 16))
                        .lineSpacing(5)

=======
                    
                    TextField("Add Name", text: $viewModel.post.ItemName)
                        .font(.custom("SF Pro", size: 16))
                        .lineSpacing(5)
                    //                    if(!Title.isEmpty){
                    //                        let _ = Show2.toggle()}

                }header: {
                    HStack{
                        Text("Item Name:")
                            .textCase(nil)
                            .font(.custom("SF Pro", size: 16))
                            .foregroundColor(.black)

                        Text("(Requier)")
                        .textCase(nil)
                        .font(.custom("SF Pro", size: 12))
=======
                        Text("(REQUIRE)")
                            .font(.custom("SF Pro", size: 10))

                    }
                    
                }
                

                    TextEditorWithPlaceholder(text: $fullText)
                        .focused($amountIsFocused)
                        .font(.custom("SF Pro", size: 16))
                        .frame(width: 355 , height: 104)
                        .padding(.top, 20)
                     //   .padding(.leading,10)
                              
                } header: {
                    HStack{
                    Text("Description:")
                            .textCase(nil)
                        .font(.custom("SF Pro", size: 16))
                       .foregroundColor(.black)
                        Text("(Optional)")
                        .textCase(nil)
                        .font(.custom("SF Pro", size: 12))
                }
=======
                Section{
                    
                    TextEditorWithPlaceholder(text: $viewModel.post.Description)
                        .font(.custom("SF Pro", size: 16))
                        .frame(width: 355 , height: 104)
                        .padding(.top, 20)
                        .padding(.leading,20)
                    
                } header: {
                    HStack{
                        Text("Description:")
                            .font(.custom("SF Pro", size: 16))
                            .foregroundColor(.black)
                        Text("(OPTIONAL)")
                            .font(.custom("SF Pro", size: 10))
                    }

                }
                
                Section{
                    Toggle(
                        isOn: $Show,
                        label:{
                            Text("Show phone number ")
                                .font(.custom("SF Pro", size: 16))
                            
                        })}
                
            footer:{
                
                Button {
                    handleDoneTapped()
//                    if(image != nil){
//                        viewModel.post.ImageURL = (image?.toJpegString(compressionQuality: 0.2))!
//                        print("happpppy to get here")
//                    }
//                    viewModel.uploadImageToStorge(image: image)
                   // viewModel.handelUploadImage(image : image!)
                } label: {
                    
                    if(!viewModel.post.ItemState.isEmpty && !viewModel.post.ItemName.isEmpty){
                        Text("POST")
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(width: 300 , height: 53)
                            .background(Color(("Mygreen")))
                            .cornerRadius(8)
                    }else{
                        Text("POST")
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(width: 300 , height: 53)
                            .background(Color(("Mygray")))
                            .cornerRadius(8)
                    }
                    
                    
                    
                }.disabled(viewModel.post.ItemState.isEmpty || viewModel.post.ItemName.isEmpty)
                    .padding(.all)
                    .disabled(!viewModel.modified)
            }
                //
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()

                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
            .pickerStyle(.inline)

            
        
=======

        }
    }
    func handleCancelTapped() {
        self.dismiss()
    }
    
    func handleDoneTapped() {
      //  self.viewModel.handleDoneTapped()
        self.viewModel.uploadImageToStorge(uuimage: image, ItemName: viewModel.post.ItemName, ItemState: viewModel.post.ItemState, Description: viewModel.post.Description)
        self.dismiss()
    }
    
    func handleDeleteTapped() {
        viewModel.handleDeleteTapped()
        self.dismiss()
        self.completionHandler?(.success(.delete))
    }
    
    func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
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


=======


let placeHolderImage = UIImage()
//
//extension UIImageView {
// // Check to see if the image is the same as our placeholder
//  func isPlaceholderImage(_ placeHolderImage: UIImage = placeHolderImage) -> Bool {
//    return image == placeHolderImage
//  }
//}


struct AddPhoto: View {
    @StateObject var viewModel = PostsViewModel()
    @Binding var image: UIImage?
//    @Binding var  UrlForImage: URL?
    //= UIImage(systemName: "")
    //Image("photo")
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    @State private var shouldPresentCamera = true
    
    var body: some View {
        // WARNING: Force wrapped image for demo purpose
        
        ZStack{
            
            let imagetoSwift = Image(uiImage: image ?? placeHolderImage)
            imagetoSwift
                .resizable()
                .frame(width: 355, height: 211)
                .cornerRadius(8)
                .overlay( RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.white), lineWidth: 1))
                .background(Color("Mygray"))
                .cornerRadius(8)
            
            if (!shouldPresentActionScheet && !shouldPresentImagePicker && shouldPresentCamera){
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 68 , height: 76)
                .foregroundColor(Color("darkgray"))}
     
        }
        
        .onTapGesture { self.shouldPresentActionScheet = true
            
        }
        .sheet(isPresented: $shouldPresentImagePicker) {
            SUImagePickerView(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary, image: self.$image, isPresented: self.$shouldPresentImagePicker)
        }.actionSheet(isPresented: $shouldPresentActionScheet) { () -> ActionSheet in
            ActionSheet(title: Text("Choose mode"), message: Text("Please choose your preferred mode to upload your item image"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
                self.shouldPresentImagePicker = true
                self.shouldPresentCamera = true
            }), ActionSheet.Button.default(Text("Photo Library"), action: {
                self.shouldPresentImagePicker = true
                self.shouldPresentCamera = false
            }), ActionSheet.Button.cancel()])
        }
    }
}

struct SUImagePickerView: UIViewControllerRepresentable {
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var image:  UIImage?
//    @Binding var UrlForImage:  URL?
    @Binding var isPresented: Bool
    
    func makeCoordinator() -> ImagePickerViewCoordinator {
        return ImagePickerViewCoordinator(image: $image, isPresented: $isPresented)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = sourceType
        pickerController.delegate = context.coordinator
        return pickerController
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // Nothing to update here
    }

}

class ImagePickerViewCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var image:  UIImage?
    @Binding var isPresented: Bool
//    @Binding var  UrlForImage: URL?
   
    init(image: Binding<UIImage?>, isPresented: Binding<Bool>) {
        self._image = image
        self._isPresented = isPresented
//        self._UrlForImage = UrlForImage
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            self.image = Image(uiImage: image)
            self.image = image
            print("this is my image \(image)")
        }
        self.isPresented = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.isPresented = false
    }
    
}

