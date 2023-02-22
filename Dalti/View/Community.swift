//
//  Community.swift
//  Dalti
//
//  Created by Sara Alhumidi on 10/07/1444 AH.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI
import UserNotifications

struct Community: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var locationManager: LocationManager
    @State var currentItem : PostModel?
    @StateObject var viewModels = PostsViewModel()
    @StateObject var viewModel = PostViewModel()
    @ObservedObject private var vm = MainMessagesViewModel()
    @ObservedObject var viewModelChat = ChatViewModel()
    @State var showDeaialPage: Bool = false
    @Namespace var animation
    @State var animateView : Bool = false
    @State var itemType = ["Lost","Found"]
    var completionHandler: ((Result<Action, Error>) -> Void)?
    @State var  ItemType = ""
    @State private var orderPlaced = false

    //  @Binding var Show: Bool
    var body: some View {
        NavigationStack{
            
            VStack {
//                Picker("Select the item state", selection: $ItemType) {
//                    ForEach(itemType, id: \.self) {
//                        Text(LocalizedStringKey($0)).foregroundColor(Color("lightGreen"))}
//                    .font(.custom("SF Pro", size: 16))
//                }.pickerStyle(.segmented)
//                    .frame(width: 345).padding(1)
                Divider()
                ScrollView(.vertical,showsIndicators: false){
                    VStack(spacing: 0){
                        ForEach(viewModels.posts){post in
                            Button{
                                withAnimation(.interactiveSpring(response: 0.6,dampingFraction: 0.7,blendDuration: 0.7)){
                                    currentItem = post
                                    showDeaialPage = true
                                }
                            }
                        label: {
                            CardView(item: post)
                                .scaleEffect(currentItem?.id == post.id && showDeaialPage ? 1 : 0.93)
                        }.buttonStyle(ScaledButtonStyle())
                                .opacity(showDeaialPage ? (currentItem?.id == post.id ? 1 : 0) : 1)
                        }
                        .onDelete() { indexSet in
                            viewModels.removePosts(atOffsets: indexSet)
                        }.padding(10)
                    }
                }
            }
//            .alert(isPresented: $locationManager.didArriveAtTakeout) {
//                Alert(
//                    title: Text("Check"),
//                    message:
//                        Text("""
//
//                        Do you want to..?
//                        """),
//                    primaryButton: .default(Text("Yes")),
//                    secondaryButton: .default(Text("No"))
//                )
//            }
            .onAppear() {
                print("PostsListView appears. and data updates.")
                self.viewModels.subscribe()
                //                locationManager.locationCurrnent()
                print("long",  locationManager.locationCurrent.longitude)
                print("lat",  locationManager.locationCurrent.longitude)
                
            }
            //            .background(Color("BackGroundColor"))
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                                    HStack {
                NavigationLink(destination: Profile(viewModelChat: viewModelChat), label:{
                    Label("Profile", systemImage: "person.circle")
                        .foregroundColor(Color("lightGreen"))
                })
            }, trailing:
                                    HStack {
                NavigationLink(destination :    MainMessagesView() , label:{
                    Label("Chat", systemImage: "message")
                        .foregroundColor(Color("lightGreen"))
                })
                
                NavigationLink(destination: Post(post: PostModel(ItemName: "", ItemState: "", Description: "", ImageURL: "", Phone: "")), label:{
                    Label("Post", systemImage: "plus")
                        .foregroundColor(Color("lightGreen"))
                })
            })
            .navigationBarTitle("Community", displayMode: .large)
            
        }.overlay{
            if let currentItem = currentItem, showDeaialPage{
                DetailView(item: currentItem).ignoresSafeArea(.container, edges: .top)
            }
        }
        .background{
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(.white)
                .frame(height: animateView ? nil : 350 , alignment: .top)
                .opacity(animateView ? 1 : 0)
                .ignoresSafeArea()
        }
        
        
    }
    
    @ViewBuilder
    func CardView(item: PostModel)-> some View{
        
        VStack(alignment: .leading, spacing: 15){
            ZStack(alignment: .topLeading){
                GeometryReader{ proxy in
                    let size = proxy.size
                    AnimatedImage(url: URL(string: item.ImageURL)).resizable()
                    //                        .placeholder(UIImage(systemName: "text.below.photo.fill"))
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .clipShape(CustomCorner(corners: [.topRight,.topLeft], radius: 8)).foregroundColor(.gray)
                    
                    
                }.frame(height: 400)
                LinearGradient(colors: [.black.opacity(0.5),.black.opacity(0.2),.clear], startPoint: .top, endPoint: .bottom).clipShape(CustomCorner(corners: [.topRight,.topLeft], radius: 8))
                VStack(alignment: .leading, spacing: 8){
                    Text(item.ItemState)
                        .font(.largeTitle.bold())
                }.foregroundColor(.white)
                    .padding()
                    .offset(y: currentItem?.id == item.id && animateView ? safeArea().top : 0)
            }
            HStack(alignment:.firstTextBaseline,spacing: 21){
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(item.ItemName).font(.callout).fontWeight(.semibold)
                        .fontWeight(.bold)
                        .foregroundColor(Color("colorOfText"))
                    // .frame(width: 335.75,height: 20.18)
                    Text(animateView ? "" : item.Description )
                        .font(.caption).fontWeight(.regular)
                        .fontWeight(.bold)
                        .foregroundColor(Color("colorOfText"))
                        .frame(width: 335.75,height: animateView ? 0 : 50.95)
                    
                }.padding([.leading,.top])
            }
        }
        .foregroundColor(Color("BackGroundColor"))
            .background{
                RoundedRectangle(cornerRadius: 8,style: .continuous).fill(Color("BackGroundColor")).shadow(radius: animateView ? 0 : 5).ignoresSafeArea()
//                    .border(animateView ? .clear : .gray,width: 1)
            }
            .matchedGeometryEffect(id: item.id, in: animation)
    }
    
    func DetailView(item: PostModel)-> some View{
        ScrollView(.vertical,showsIndicators: false){
            VStack{
                CardView(item: item)
                    .scaleEffect(animateView ? 1 : 0.87)
                VStack(spacing: 15){
                    if (item.Description != ""){
                        Text(item.Description).multilineTextAlignment(.leading).lineSpacing(10).padding(.bottom,20).frame(height: 200)}
                    else{
                        Text( "the item in the photo above is missing please contact the person who post it by call or chat within the app, help people to find their items and they will help you too..").multilineTextAlignment(.leading).lineSpacing(10).frame(height: 200).padding(.bottom,20)
                        
                    }
                    Spacer()
                    Divider()
                    HStack{
                        //                        let phonenum = "03030339"
                        if(item.Phone != ""){
                            Button{
                                let tel = "tel://"
                                let formattedString = tel + item.Phone
                                guard let url = URL(string: formattedString) else { return }
                                UIApplication.shared.open(url)
                            } label: {
                                Text("Call")
                            }
                        }
                        
                    }
                    
                }.padding()
            }
        }
        .overlay(alignment: .topTrailing, content: {
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
            }
        label: {
            Image(systemName: "xmark.circle.fill")
                .font(.title)
                .foregroundColor(.white)
        }.padding()
                .padding(.top,safeArea().top)
                .offset(y: -10)
                .opacity(animateView ? 1 : 0)
        })
        .background{
            RoundedRectangle(cornerRadius: 8,style: .continuous).fill(Color("BackGroundColor"))
        }
        .onAppear{
            withAnimation(.interactiveSpring(response: 0.6,
                                             dampingFraction: 0.7 ,blendDuration: 0.7)){
                animateView = true
            }
        }
        .transition(.identity)
    }
    func placeOrder() {
        orderPlaced = true
    }
    
    func requestNotification() {
        locationManager.validateLocationAuthorizationStatus()
    }
    func handleDeleteTapped() {
        viewModel.handleDeleteTapped()
        self.dismiss()
        completionHandler?(.success(.delete))
    }
    
    func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
}
struct Community_Previews: PreviewProvider {
    static var previews: some View {
        Community()
        //.environmentObject(locationManager)
    }
}
