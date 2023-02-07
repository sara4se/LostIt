//
//  Post.swift
//  Dalti
//
//  Created by Sara Alhumidi on 10/07/1444 AH.
//

import SwiftUI
import UIKit

struct Post: View {
    var body: some View {
        NavigationStack{
            ZStack {
           
                VStack{
                    
//                    Text("Item Image:")
//                        .padding(.trailing,250)
//                    AddPhoto()
                    ItemType()
                  
                
                }
             
            }.toolbar{
                NavigationLink(destination: Chat(), label:{
                    Label("Chat", systemImage: "message")
                        .foregroundColor(.black)
                })
            }
            .navigationBarTitle("Post", displayMode: .large)
        }
        
        
    }
}

struct Post_Previews: PreviewProvider {
    static var previews: some View {
        Post()
    }
}

struct AddPhoto: View {
 
    @State private var image: Image? = Image("photo")
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    @State private var shouldPresentCamera = false
    
    var body: some View {
        // WARNING: Force wrapped image for demo purpose
        ZStack{  image!
                .resizable()
                .frame(width: 355, height: 211)
                .cornerRadius(8)
                .overlay( RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.white), lineWidth: 1))
                .background(Color("Mygray"))
                .cornerRadius(8)
                Image(systemName: "plus")
                .resizable()
                .frame(width: 68 , height: 76)
                .foregroundColor(Color("+"))

        }
           
            .onTapGesture { self.shouldPresentActionScheet = true }
            .sheet(isPresented: $shouldPresentImagePicker) {
                SUImagePickerView(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary, image: self.$image, isPresented: self.$shouldPresentImagePicker)
        }.actionSheet(isPresented: $shouldPresentActionScheet) { () -> ActionSheet in
            ActionSheet(title: Text("Choose mode"), message: Text("Please choose your preferred mode to set your profile image"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
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
    @Binding var image: Image?
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
    
    @Binding var image: Image?
    @Binding var isPresented: Bool
    
    init(image: Binding<Image?>, isPresented: Binding<Bool>) {
        self._image = image
        self._isPresented = isPresented
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.image = Image(uiImage: image)
        }
        self.isPresented = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.isPresented = false
    }
    
}

struct ItemType: View {
    var itemType = ["Select","Lost","Found"]
    @State var  ItemType = "Select"
    @State var Title : String = ""
    @State var fullText: String = "Item color, location..."
    
    var body: some View {
        ZStack {
            Color.purple
            .ignoresSafeArea()
            Form {
                
                    Text("Item Image:")
                    AddPhoto()
                    
                
                Section {
                    Picker("Select the item state", selection: $ItemType) {
                        ForEach(itemType, id: \.self) {
                            Text($0)}
                       
                        
                    }
                    
                }
                Section{
                    Text("Item Name:")
                    TextField("Add Title", text: $Title)
                }
                
                Section{
                    Text("Description:")
                    TextEditor(text: $fullText)
                               .foregroundColor(Color.gray)
                               .font(.custom("HelveticaNeue", size: 13))
                               .lineSpacing(5)
                }
                Button {
                    
                } label: {
                                       Text("POST")
                        .background(.gray)
                    //    .font(.headline)
                        .foregroundColor(.white)
                        .background(.gray)
                                      
                }

//                Button( action: {
//
//                } , label: {
//                   Text("POST")
//                        .padding()
//                        .frame(minWidth: .infinity)
//                        .background(.gray.cornerRadius(10))
//                        .foregroundColor(.white)
//                        .font(.headline)
//                })
            }
            .pickerStyle(MenuPickerStyle())
        }
    }
}
