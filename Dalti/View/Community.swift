//
//  Community.swift
//  Dalti
//
//  Created by Sara Alhumidi on 10/07/1444 AH.
//

import SwiftUI

import Firebase
import SDWebImageSwiftUI
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
=======
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


=======

struct Community: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var currentItem : PostModel?
    @StateObject var viewModels = PostsViewModel()
    @StateObject var viewModel = PostViewModel()
    @State var showDeaialPage: Bool = false
    @Namespace var animation
    @State var animateView : Bool = false
    @State var itemType = ["Lost","Found"]

    var completionHandler: ((Result<Action, Error>) -> Void)?
=======

    @State var  ItemType = ""
    @State var dummyText = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum"
    var body: some View {
        NavigationStack{
            VStack {
                Divider()
                Picker("Select the item state", selection: $ItemType) {
                    ForEach(itemType, id: \.self) {
                        Text($0).foregroundColor(Color("lightGreen"))}
                    .font(.custom("SF Pro", size: 16))

=======



                }.pickerStyle(.segmented)
                    .frame(width: 345).padding(1)
                
                ScrollView(.vertical,showsIndicators: false){
                    VStack(spacing: 0){

                        ForEach(viewModels.posts){post in
=======
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
                                    currentItem = post
                                    showDeaialPage = true
                                }
                            }
                        label: {

                            CardView(item: post).overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color("cornerColor"), lineWidth: 1)
                            )
                            .scaleEffect(currentItem?.id == post.id && showDeaialPage ? 1 : 0.93)
=======
                            CardView(item: item).overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color("cornerColor"), lineWidth: 1)
                            )
                                .scaleEffect(currentItem?.id == item.id && showDeaialPage ? 1 : 0.93)

                        }.buttonStyle(ScaledButtonStyle())
                                .opacity(showDeaialPage ? (currentItem?.id == post.id ? 1 : 0) : 1)
                        }
                        .onDelete() { indexSet in
                            viewModels.removePosts(atOffsets: indexSet)
                        }.padding(10)
                    }
                }

            }.onAppear() {
                print("PostsListView appears. and data updates.")
                self.viewModels.subscribe()
            }
            .background(Color("lightWhite"))
            
=======
            }.background(Color("lightWhite"))
         

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

                    
=======
//                    Picker("Select the item state", selection: $ItemType) {
//                        ForEach(itemType, id: \.self) {
//                            Text($0)}
//                        .font(.custom("SF Pro", size: 16))
//
//
//                    }.pickerStyle(.segmented)


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
            
=======
    func CardView(item: TodayItem)-> some View{
        
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
                //                LinearGradient(colors: [.black.opacity(0.5),.black.opacity(0.2),.clear], startPoint: .top, endPoint: .bottom).clipShape(CustomCorner(corners: [.topRight,.topLeft], radius: 8))
                VStack(alignment: .leading, spacing: 8){
                    Text(item.ItemName.uppercased())
                        .font(.callout).fontWeight(.semibold)
                    Text(item.ItemState.uppercased())
=======
                    
                }.frame(height: 400)
//                LinearGradient(colors: [.black.opacity(0.5),.black.opacity(0.2),.clear], startPoint: .top, endPoint: .bottom).clipShape(CustomCorner(corners: [.topRight,.topLeft], radius: 8))
                VStack(alignment: .leading, spacing: 8){
                    Text(item.title.uppercased())
                        .font(.callout).fontWeight(.semibold)
                    Text(item.category.uppercased())

                        .font(.largeTitle.bold())
                }.foregroundColor(.white)
                    .padding()
                    .offset(y: currentItem?.id == item.id && animateView ? safeArea().top : 0)
            }
            HStack(alignment:.firstTextBaseline,spacing: 21){
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("title").font(.callout).fontWeight(.semibold)
                        .fontWeight(.bold)
                        .foregroundColor(.black)

                    // .frame(width: 335.75,height: 20.18)
                    if (!animateView){
                        Text(item.Description).font(.caption).fontWeight(.regular)
=======
                       // .frame(width: 335.75,height: 20.18)
                    if (!animateView){
                        Text(dummyText).font(.caption).fontWeight(.regular)

                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(width: 335.75,height: 31.95)
                    }
                }.padding([.leading,.top])
            }
        }
        .background{
            RoundedRectangle(cornerRadius: 8,style: .continuous).fill(.white)
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
        }) .background{
            RoundedRectangle(cornerRadius: 8,style: .continuous).fill(.white)
        }
        .onAppear{
            withAnimation(.interactiveSpring(response: 0.6,
                                             dampingFraction: 0.7 ,blendDuration: 0.7)){
                animateView = true
            }
        }
        .transition(.identity)
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
