//
//  ScaledButtonStyle.swift
//  Dalti
//
//  Created by Sara Alhumidi on 14/07/1444 AH.
//

import SwiftUI

struct ScaledButtonStyle: ButtonStyle{
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}
extension Double{
    func fixedFraction(digits: Int) -> String {
        .init(format: "%.*f", digits, self)
    }
}
extension View {
    func safeArea()->UIEdgeInsets{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene
        else{
            return .zero
        }
        guard let safeArea = screen.windows.first?.safeAreaInsets else{
            return .zero
        }
        return safeArea
    }
}

extension View {
    func navigationBarItems<L, C, T>(leading: L, center: C, trailing: T) -> some View where L: View, C: View, T: View {
        self.navigationBarItems(leading:
                                    HStack{
            HStack {
                leading
            }
            .frame(width: 60, alignment: .leading)
            Spacer()
            HStack {
                center
            }
            .frame(width: 300, alignment: .center)
            Spacer()
            HStack {
                //Text("asdasd")
                trailing
            }
            //.background(Color.blue)
            .frame(width: 100, alignment: .trailing)
        }
                                //.background(Color.yellow)
            .frame(width: UIScreen.main.bounds.size.width-32)
        )
    }
}

enum LaunchScreenStep {
    case firstStep
    case secondStep
    case finished
}

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
struct DotView: View {
    @State var delay: Double = 0 // 1.
    @State var scale: CGFloat = 0.5
    var body: some View {
        Circle()
            .frame(width: 10, height: 10).foregroundColor(Color("Mygreen"))
            .scaleEffect(scale)
            .animation(Animation.easeInOut(duration: 0.6).repeatForever().delay(delay)) // 2.
            .onAppear {
                withAnimation {
                    self.scale = 1
                }
            }
    }
}
