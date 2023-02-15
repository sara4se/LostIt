//
//  Imagepicker.swift
//  Dalti
//
//  Created by Mashael Alharbi on 07/02/2023.
//

import Foundation
import SwiftUI

enum DefaultSettings {
    // Profile
    static var name: String = "Ahmad Ali"
    static var phone: String = "0597223332"
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var avatarImage: UIImage
    @Environment(\.presentationMode) var presentationMode
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

struct User{
    var name = "Ahmad"
    var userName = "username"
    var password = "default pass"
    var email = "default email"
    var bio = "default Bio"
    var Phone = "0597223332"
    
}

var currentUser = User()

extension ImagePicker {
    
    class Coordinator: NSObject, UINavigationControllerDelegate , UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else { return }
            parent.selectedImage = image
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
