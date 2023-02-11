//
//  SwiftUIView.swift
//  Dalti
//
//  Created by Milah Alfaqeeh  on 09/02/2023.
//

import SwiftUI

struct ItemType2: View {
    @State var itemType = ["Lost","Found"]
    @State var  ItemType = ""
    @State var Title : String = ""
    @State var fullText: String = ""
    @State var Show: Bool = true
    @State var Show2: Bool = false
    var body: some View {
        ZStack {
          
            Form{
                
                Section{

                    AddPhoto()}header: {
                        HStack{
                            Text("Item Image:")
                                .font(.custom("SF Pro", size: 16))
                                .foregroundColor(.black)
                          
                            Text("(OPTIONAL)")
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
                        .font(.custom("SF Pro", size: 16))
                        .lineSpacing(5)
//                    if(!Title.isEmpty){
//                        let _ = Show2.toggle()}
                }header: {
                    HStack{
                        Text("Item Name:")
                            .font(.custom("SF Pro", size: 16))
                        .foregroundColor(.black)
                        Text("(REQUIRE)")
                            .font(.custom("SF Pro", size: 10))
                    }
                    
                }

                Section{
                
                    TextEditorWithPlaceholder(text: $fullText)
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
                Section{
                    Button {
                       
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
                     //   .listRowBackground(Color.clear)
                     //   .buttonStyle(BackgroundStyle(Color.clear))
                     
                   
                }
              

            }
            .pickerStyle(.inline)
           
        }
    }
   
}


struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ItemType2()
    }
}
