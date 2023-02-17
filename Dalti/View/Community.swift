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
    @State var showDeaialPage: Bool = false
    @Namespace var animation
    @State var animateView : Bool = false
    @State var itemType = ["Lost","Found"]
    var completionHandler: ((Result<Action, Error>) -> Void)?
    @State var  ItemType = ""
    @State var dummyText = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum"
    var body: some View {
        NavigationStack{
            VStack {
//                Picker(selection: $selectedSchool, label: Text("School Name")) {
//                    ForEach(self.schoolData.datas.sorted(by: { $0.name < $1.name } )) {i in
//                        Text(self.schoolData.datas.count != 0 ? i.name : "No Schools Available").tag(i as schoolName?)
//                    }
//                }
//                Text("Selected School: \(selectedSchool?.name ?? "No School Selected")")
//
//                Divider()
                Picker("Select the item state", selection: $ItemType) {
                    ForEach(itemType, id: \.self) {
                        Text($0).foregroundColor(Color("lightGreen"))}
                    .font(.custom("SF Pro", size: 16))
                }.pickerStyle(.segmented)
                    .frame(width: 345).padding(1)
                
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
                            //                                .overlay(
                            //                                RoundedRectangle(cornerRadius: 8)
                            //                                    .stroke(Color("cornerColor"), lineWidth: 1)
                            //                            )
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
            .onAppear() {
                print("PostsListView appears. and data updates.")
                self.viewModels.subscribe()
                locationManager.locationCurrnent()
                print("long",  locationManager.locationCurrnent().longitude)
                print("lat",  locationManager.locationCurrnent().latitude)
            }
            .background(Color("BackGroundColor"))
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                                    HStack {
                NavigationLink(destination: Profile(), label:{
                    Label("Profile", systemImage: "person.circle")
                        .foregroundColor(Color("lightGreen"))
                })
            }, trailing:
                                    HStack {
                NavigationLink(destination: Chat(), label:{
                    Label("Chat", systemImage: "message")
                        .foregroundColor(Color("lightGreen"))
                })
                
                NavigationLink(destination: Post(post: PostModel(ItemName: "", ItemState: "", Description: "", ImageURL: "")), label:{
                    Label("Post", systemImage: "plus")
                        .foregroundColor(Color("lightGreen"))
                })
            })
            .toolbar {
                ToolbarItem(placement: .status) {
                    
                }
            }
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
    func CardView(item: PostModel)-> some View{
        
        VStack(alignment: .leading, spacing: 15){
            
            ZStack(alignment: .topLeading){
                GeometryReader{ proxy in
                    let size = proxy.size
                    //                    Image("image2")
                    //                    if let encodedString = item.ImageURL.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed), let url = URL(string: encodedString) {
                    //                     let _ =   print("url ***************\(url)")
                    //                        if let urltoImage = url, let data = try? Data(contentsOf: urltoImage),
                    //                           let image = UIImage(data: data){
                    //                            let _ =   print("data **************\(data)")
                    //                            Image(uiImage: image)
                    //                            //                    Image(uiImage: item.ImageURL)
                    //                                .resizable()
                    AnimatedImage(url: URL(string: item.ImageURL)).resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .clipShape(CustomCorner(corners: [.topRight,.topLeft], radius: 8))
                    
                    
                }.frame(height: 400)
                                LinearGradient(colors: [.black.opacity(0.5),.black.opacity(0.2),.clear], startPoint: .top, endPoint: .bottom).clipShape(CustomCorner(corners: [.topRight,.topLeft], radius: 8))
                VStack(alignment: .leading, spacing: 8){
                    Text(item.ItemState.uppercased())
                        .font(.largeTitle.bold())
                }.foregroundColor(Color("colorOfText"))
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
                            .frame(width: 335.75,height: 31.95)
                    
                }.padding([.leading,.top])
            }
        }.foregroundColor(Color("BackGroundColor"))
        .background{
            RoundedRectangle(cornerRadius: 8,style: .continuous).fill(Color("BackGroundColor")).border(animateView ? .clear : .gray,width: 1)
        }
        .matchedGeometryEffect(id: item.id, in: animation)
    }
    
    func DetailView(item: PostModel)-> some View{
        ScrollView(.vertical,showsIndicators: false){
            VStack{
                CardView(item: item)
                    .scaleEffect(animateView ? 1 : 0.93)
                VStack(spacing: 15){
                    Text(item.Description).multilineTextAlignment(.leading).lineSpacing(10).padding(.bottom,20)
                    Divider()
                    HStack{
                        let PhoneNumber = "123-456-7890"
                        Button{
                            let tel = "tel://"
                            let formattedString = tel + PhoneNumber
                            guard let url = URL(string: formattedString) else { return }
                            UIApplication.shared.open(url)
                        } label: {
                            Text("Call")
                        }
                        Button{
                            requestNotification()
                             print("this is loction manger resilt ",locationManager.didArriveAtTakeout)
                            if (locationManager.didArriveAtTakeout){
                                
//                                let content = UNMutableNotificationContent()
//                                content.title = "Feed the cat"
//                                content.subtitle = "It looks hungry"
//                                content.sound = UNNotificationSound.default
//
//                                // show this notification five seconds from now
//                                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//
//                                // choose a random identifier
//                                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//
//                                // add our notification request
//                                UNUserNotificationCenter.current().add(request)
    //                            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
    //                                if success {
    //                                    print("All set!")
    //                                } else if let error = error {
    //                                    print(error.localizedDescription)
    //                                }
    //                            }
                            }
                        
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
    }
}
