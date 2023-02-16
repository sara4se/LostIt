//
//  Post.swift
//  Dalti
//
//  Created by Sara Alhumidi on 10/07/1444 AH.
//

import SwiftUI
import UIKit

struct Post: View {
    @EnvironmentObject private var locationManager: LocationManager
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
    @EnvironmentObject private var locationManager: LocationManager
    static var previews: some View {
        Post()
    }
}

struct AddPhoto: View {
 
    @State private var image: Image? = Image("photo")
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    @State private var shouldPresentCamera = true
    
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
            if (!shouldPresentActionScheet && !shouldPresentImagePicker && shouldPresentCamera){
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 68 , height: 76)
                .foregroundColor(Color("darkgray"))}

        }
           
            .onTapGesture { self.shouldPresentActionScheet = true }
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
    @EnvironmentObject private var locationManager: LocationManager
    @State private var Save = false
    @State var itemType = ["Select","Lost","Found"]
    @State var  ItemType = ""
    @State var Title : String = ""
    @State var fullText: String = ""
    @State var Show: Bool = true
    @State var Show2: Bool = false
    @FocusState private var amountIsFocused: Bool
    var body: some View {
        ZStack {
            VStack {
              
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
                        }
                    
                    Section {
                        Picker("Select the item state", selection: $ItemType) {
                            ForEach(itemType, id: \.self) {
                                Text($0)}
                            .font(.custom("SF Pro", size: 16))
                            if(!ItemType.isEmpty){
                                let _ = Show2.toggle()}
                        }.pickerStyle(.navigationLink)
                    }
                    Section{

                        TextField("Add Name", text: $Title)
                            .focused($amountIsFocused)
                            .font(.custom("SF Pro", size: 16))
                            .lineSpacing(5)

                    }header: {
                        HStack{
                            Text("Item Name:")
                                .textCase(nil)
                                .font(.custom("SF Pro", size: 16))
                                .foregroundColor(.black)
                            Text("(Requier)")
                            .textCase(nil)
                            .font(.custom("SF Pro", size: 12))
                        }
                        
                    }

                    Section{
                    
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
                               CheckAuth()
                        } label: {
                          if(!ItemType.isEmpty && !Title.isEmpty){
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

                              
                            
                        }.disabled(ItemType.isEmpty || Title.isEmpty)
                        .padding(.all)
                }
                      

                    

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
                
            
            }
            .alert(isPresented: $Save) {
                Alert(
                  title: Text("Notifition"),
                  message:
                    Text("""
                      your post is updated .
                      Would you like to be notified on near by post ?
                      """),
                  primaryButton: .default(Text("Yes")) {
                    requestNotification()
                  },
                  secondaryButton: .default(Text("No"))
                )
        }
        }
    }
    
    func CheckAuth() {
        Save = true
    }

    func requestNotification() {
      locationManager.validateLocationAuthorizationStatus()
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

