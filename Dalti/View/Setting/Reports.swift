//
//  Delete account.swift
//  Dalti
//
//  Created by Mashael Alharbi on 13/02/2023.
//

import SwiftUI

struct Reports: View {
    @StateObject var viewModels = PostsViewModel()
    @Environment(\.presentationMode) private var presentationMode
    @State var item: PostModel
    @State var Id : String
    @State var reprtDisc : String = ""
    @State var reportDone : Bool = false
    @State var reportCount = 0
    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackGroundColor").ignoresSafeArea()
                Form{
                    Section{
                        
                        TextField("Reporting", text: $Id)
                            .font(.custom("SF Pro", size: 16))
                            .lineSpacing(5)
                    }header: {
                        HStack{
                            Text("Reporting").textCase(nil)
                                .font(.custom("SF Pro", size: 16))
                                .foregroundColor(Color("colorOfText"))
                            
                        }
                    }
                    Section{
                        
                        TextEditorWithPlaceholder(text: $reprtDisc )
                            .font(.custom("SF Pro", size: 16))
                            .frame(width: 355 , height: 104)
                            .padding(.top, 20)
                            .padding(.leading,20)
                        
                    } header: {
                        HStack{
                            Text("Why reporting this post?").textCase(nil)
                                .font(.custom("SF Pro", size: 16))
                                .foregroundColor(Color("colorOfText"))
                        }
                    }
                    
                footer:{
//                     var myInt = Int(item.report)
                    Button {
                        reportDone.toggle()
                        
                    } label: {
                        
                        if(!reprtDisc.isEmpty){
                            Text("Report")
                                .foregroundColor(.white)
                                .font(.headline)
                                .frame(width: 300 , height: 53)
                                .background(Color(("Mygreen")))
                                .cornerRadius(8)
                                .shadow(radius: 3)
                        }else{
                            Text("Report")
                                .foregroundColor(.white)
                                .font(.headline)
                                .frame(width: 300 , height: 53)
                                .background(Color(("Mygray")))
                                .cornerRadius(8)
                                .shadow(radius: 3)
                        }
                    }.disabled(reprtDisc.isEmpty)
                        .padding(.all)
                        .alert(isPresented: $reportDone) {
//                            myInt! += 1
//                            reportCount = myInt!
                            viewModels.updatePost(report:  reprtDisc, item)
//                            print(" report Count ",myInt!)
                            print(" report Count ",reportCount)
                            return Alert(title: Text("Post Reported!"), message: Text("Are you sure you want to report this post"), primaryButton: .destructive(Text("Report")){
                                viewModels.reportPost(report: reprtDisc, item)
                                dismiss()
                                print("reports...")
                            },   secondaryButton: .cancel())

                        }
                }
                }.pickerStyle(.inline)
            }.navigationBarTitle("Reporting an issue", displayMode: .large)
        }
    }
    func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
//    func report() {
//        print(" he enter report", reportCount)
//        if reportCount > 10{
//            print(" he enter report")
//            viewModel.removePost()
//    //        self.dismiss()
//            completionHandler?(.success(.delete))
//
//        }
//    }
}
struct Reports_Previews: PreviewProvider {
    static var previews: some View {
        Reports(item: PostModel(ItemName: "", ItemState: "", Description: "", ImageURL: "", Phone: "", report: ""), Id: "")
    }
}
