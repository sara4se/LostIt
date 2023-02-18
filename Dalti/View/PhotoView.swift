//
//  PhotoView.swift
//  Dalti
//
//  Created by Sara Alhumidi on 27/07/1444 AH.
//

import SwiftUI

struct PhotoView: View {
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
                .background(Color("cornerColor"))
                .cornerRadius(8)
            
            if (!shouldPresentActionScheet && !shouldPresentImagePicker && shouldPresentCamera){
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 68 , height: 76)
                .foregroundColor(Color("darkgray"))
                
            }
     
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


struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoView(image: .constant(placeHolderImage))
    }
}
