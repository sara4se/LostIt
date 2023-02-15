//
//  Community.swift
//  Dalti
//
//  Created by Sara Alhumidi on 10/07/1444 AH.
//

import SwiftUI
struct Community: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var currentItem : TodayItem?
    @State var showDeaialPage: Bool = false
    @Namespace var animation
    @State var animateView : Bool = false
    
    @State var dummyText = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum"
    
    var body: some View {
        NavigationStack{
            VStack {
                ScrollView(.vertical,showsIndicators: false){
                    VStack(spacing: 0){
//                        HStack(alignment: .bottom){
//                            VStack(alignment: .leading, spacing: 8){
//                                Text("Day 1").font(.callout).foregroundColor(.gray)
//                            }
//                        }  .padding(.horizontal)
//                            .padding(.bottom)
//                            .opacity(showDeaialPage ? 0 : 1)
                        ForEach(items){item in
                            Button{
                                withAnimation(.interactiveSpring(response: 0.6,dampingFraction: 0.7,blendDuration: 0.7)){
                                    currentItem = item
                                    showDeaialPage = true
                                }
                            }
                        label: {
                            CardView(item: item)
                                .scaleEffect(currentItem?.id == item.id && showDeaialPage ? 1 : 0.93)
                        }.buttonStyle(ScaledButtonStyle())
                                .opacity(showDeaialPage ? (currentItem?.id == item.id ? 1 : 0) : 1)
                        }.padding(10)
                    }
                }
            }
         
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
//                                    HStack {
//                NavigationLink(destination: Profile(), label:{
//                    Label("Profile", systemImage: "person.circle")
//                        .foregroundColor(.black)
//                })
//            }, trailing:
                                    HStack {
                NavigationLink(destination: Chat(), label:{
                    Label("Chat", systemImage: "message")
                        .foregroundColor(.black)
                })
                
                NavigationLink(destination: Post(), label:{
                    Label("Post", systemImage: "plus")
                        .foregroundColor(.black)
                })
            })
            
            //.navigationBarItems(leading: btnBack)
            .navigationBarTitle("Community", displayMode: .large)
            
            
        }.overlay{
            if let currentItem = currentItem, showDeaialPage{
                DetailView(item: currentItem).ignoresSafeArea(.container, edges: .top)
            }
        }
        .background(alignment: .top){
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(.white)
                .frame(height: animateView ? nil : 350 , alignment: .top)
                .opacity(animateView ? 1 : 0)
                .ignoresSafeArea()
    }
        
      
    }
    
    @ViewBuilder
    func CardView(item: TodayItem)-> some View{
        VStack(alignment: .leading, spacing: 15){
            ZStack(alignment: .topLeading){
                GeometryReader{proxy in
                    let size = proxy.size
                    Image("image2")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .clipShape(CustomCorner(corners: [.topLeft,.topRight,.bottomLeft,.bottomRight], radius: 15))
                    
                }.frame(height: 400)
                LinearGradient(colors: [.black.opacity(0.5),.black.opacity(0.2),.clear], startPoint: .top, endPoint: .bottom)
//                VStack(alignment: .leading, spacing: 8){
//                    Text(item.title.uppercased())
//                        .font(.callout).fontWeight(.semibold)
//                    Text(item.category.uppercased())
//                        .font(.largeTitle.bold())
//                }.foregroundColor(.white)
//                    .padding()
//                    .offset(y: currentItem?.id == item.id && animateView ? safeArea().top : 0)
            }
            HStack(spacing: 12){
                Text("title").font(.callout).fontWeight(.semibold)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(width: 60,height: 60)
            }
            .padding([.horizontal,.bottom])
        }
        .background{
            RoundedRectangle(cornerRadius: 15,style: .continuous).fill(.white)
        }
        .matchedGeometryEffect(id: item.id, in: animation)
    }
    
    func DetailView(item: TodayItem)-> some View{
        ScrollView(.vertical,showsIndicators: false){
            VStack{
                CardView(item: item)
                    .scaleEffect(animateView ? 1 : 0.93)
                VStack(spacing: 15){
                    Text(dummyText).multilineTextAlignment(.leading).lineSpacing(10).padding(.bottom,20)
                    Divider()
                    HStack{
                        Button{
                            
                        }
                    label: {
                        Text("Call")
                    }
                        Button{
                            
                        }
                    label: {
                        Text("Chat")
                    }
                        
                    }
                    
                }.padding()
            }
        }.overlay(alignment: .topTrailing, content: {
            Button{
                withAnimation(.interactiveSpring(response: 0.6,
                                                 dampingFraction: 0.7 ,blendDuration: 0.7)){
                    animateView = false
                }
                withAnimation(.interactiveSpring(response: 0.6,
                                                 dampingFraction: 0.7 ,blendDuration: 0.7).delay(0.05)){
                    currentItem = nil
                    showDeaialPage = false
                }
            }label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundColor(.white)
            }.padding()
                .padding(.top,safeArea().top)
                .offset(y: -10)
                .opacity(animateView ? 1 : 0)
        })
        .onAppear{
            withAnimation(.interactiveSpring(response: 0.6,
                                             dampingFraction: 0.7 ,blendDuration: 0.7)){
                animateView = true
            }
        }
        .transition(.identity)
    }
}
struct Community_Previews: PreviewProvider {
    static var previews: some View {
        Community()
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
