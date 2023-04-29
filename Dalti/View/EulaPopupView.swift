//
//  EulaPopupView.swift
//  Dalti
//
//  Created by Sara Alhumidi on 09/10/1444 AH.
//

import SwiftUI

struct EulaPopupView: View {
    @AppStorage("isEulaPopup") var isEulaPopup: Bool?
//    @AppStorage("isOnboarding") var isOnboarding: Bool?
    @State private var acceptCheckbox = false
    @State var isClick : Bool = false
    @State var isClickno : Bool = false
    @Binding var isPresented: Bool
    let eulaText = """
END-USER LICENSE AGREEMENT (EULA) FOR LostIt : post lost item
    PLEASE READ THIS EULA CAREFULLY BEFORE USING LostIt : post lost item (THE APP). BY USING THE APP, YOU ARE AGREEING TO BE BOUND BY THE TERMS OF THIS EULA.

    LICENSE GRANT.
    Subject to the terms and conditions of this EULA, you are hereby granted a non-exclusive, non-transferable, revocable license to use the App for your personal, non-commercial use only on an iOS device that you own or control.

    USER CONTENT.
    The App allows you to create content, such as text and images. You retain all ownership rights in your User Content. By submitting User Content through the App, you grant us a non-exclusive, transferable, sub-licensable, royalty-free, worldwide license to use, copy, modify, create derivative works based on, distribute, publicly display, publicly perform, and otherwise exploit in any manner such User Content in all formats and distribution channels now known or hereafter devised (including in connection with the App and our business and on third-party sites and services), without further notice to or consent from you, and without the requirement of payment to you or any other person or entity.

    FEEDBACK.
    If you provide us with any feedback or suggestions regarding the App, you grant us a non-exclusive, transferable, sub-licensable, royalty-free, worldwide license to use, copy, modify, create derivative works based on, distribute, publicly display, publicly perform, and otherwise exploit in any manner such feedback and suggestions in all formats and distribution channels now known or hereafter devised (including in connection with the App and our business and on third-party sites and services), without further notice to or consent from you, and without the requirement of payment to you or any other person or entity.

    OWNERSHIP.
    You acknowledge that the App, its contents, and our trademarks are our exclusive intellectual property. We reserve all rights not expressly granted to you.

    NO COLLECTION OF PERSONAL INFORMATION.
    The App does not collect any personal information from you.

    DISCLAIMER OF WARRANTIES.
    THE APP IS PROVIDED ON AN "AS IS" AND "AS AVAILABLE" BASIS, WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION ANY WARRANTY FOR INFORMATION, SERVICES, UNINTERRUPTED ACCESS, OR PRODUCTS PROVIDED THROUGH OR IN CONNECTION WITH THE APP, INCLUDING WITHOUT LIMITATION THE SOFTWARE LICENSED TO YOU AND THE RESULTS OBTAINED THROUGH THE APP. SPECIFICALLY, WE DISCLAIM ANY AND ALL WARRANTIES, INCLUDING WITHOUT LIMITATION: 1) ANY WARRANTIES CONCERNING THE AVAILABILITY, ACCURACY, USEFULNESS, OR CONTENT OF INFORMATION, PRODUCTS OR SERVICES AND 2) ANY WARRANTIES OF TITLE, WARRANTY OF NON-INFRINGEMENT, WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.

    LIMITATION OF LIABILITY.
    WE WILL NOT BE LIABLE FOR ANY INDIRECT, INCIDENTAL, CONSEQUENTIAL, SPECIAL, OR PUNITIVE DAMAGES OF ANY KIND ARISING FROM THE USE OF THE APP, INCLUDING WITHOUT LIMITATION DAMAGES FOR LOSS OF PROFITS, USE, DATA, OR OTHER INTANGIBLES, WHETHER BASED IN CONTRACT, TORT, STRICT LIABILITY, OR OTHERWISE, EVEN IF WE HAVE BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. IN NO EVENT WILL OUR LIABILITY FOR ANY DAMAGES ARISING FROM THE USE OF THE APP EXCEED THE AMOUNT PAID BY YOU, IF ANY, FOR USING THE APP.

    CONTACT US.
    If you have any questions about this EULA, please contact us at sara.alhumidi4@gmail.com.

    APPLE APP STORE.
    This EULA is between you and us, and not with Apple. Apple is not responsible for the App or the content
"""
    var body: some View {
        
        VStack {
            Text("End-User License Agreement")
                .font(.title)
                .padding()
            Divider()
            VStack {
                ScrollView {
                    Text(eulaText)
                        .multilineTextAlignment(.leading)
                        .padding()
                    HStack {
                        Spacer()
                        Toggle("I Read the terms", isOn: $acceptCheckbox)
                            .padding()
                    }.padding()
                }
                
                Divider()
                
                HStack {
                    Spacer()
                    if (acceptCheckbox){
                        Button("Accept") {
                            isPresented = true
                            isEulaPopup = true
                            isClick = true
                        }.disabled(!acceptCheckbox)
                       
                    }
                }
                .padding()
            }
        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .frame(maxWidth: 600, maxHeight: 700)
          .background(Color.white)
//          .cornerRadius(10)
          .padding()
//          .shadow(radius: 10)
          .navigationBarBackButtonHidden()
        NavigationLink("", isActive: $isClick) {
            Splash()
        }
//        NavigationLink("", isActive: $isClickno) {
//            OnboardingContainerView()
//            let _ = isClickno.toggle()
//        }
    }
}
struct EulaPopupView_Previews: PreviewProvider {
    static var previews: some View {
        EulaPopupView(isPresented: .constant(true))
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.gray)
    }
}
