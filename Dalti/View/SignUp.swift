//
//  SignUn.swift
//  Dalti
//
//  Created by Sara Alhumidi on 10/07/1444 AH.
//

import SwiftUI

struct SignUp: View {
    var body: some View {
        NavigationStack{
            
            NavigationLink {
                // destination view to navigation to
                Community()
            } label: {
                Text("Sign Up Page")
                    .foregroundColor(.gray)
            }
            .navigationBarTitle("Sign Up", displayMode: .large)
        }
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}

//
//struct StickyNote: Shape {
//   func path(in rect: CGRect) -> Path {
//       let height = rect.height
//       let width = rect.width
//       let cornerRadius = height * 0.15
//       let cornerSize = CGSize(width: cornerRadius, height: cornerRadius)
//       let path = UIBezierPath()
//       
//       path.move(to: CGPoint(x: 0, y: 0))
//       path.addLine(to: CGPoint(x: 0, y: height - cornerRadius))
//       path.addArc(withCenter: CGPoint(x: cornerRadius, y: height - cornerRadius),
//                   radius: cornerRadius,
//                   startAngle: Angle(degrees: 180).radians,
//                   endAngle: Angle(degrees: 270).radians,
//                   clockwise: true)
//       path.addLine(to: CGPoint(x: width - cornerRadius, y: height))
//       path.addArc(withCenter: CGPoint(x: width - cornerRadius, y: height - cornerRadius),
//                   radius: cornerRadius,
//                   startAngle: Angle(degrees: 270).radians,
//                   endAngle: Angle(degrees: 0).radians,
//                   clockwise: true)
//       path.addLine(to: CGPoint(x: width, y: 0))
//       path.close()
//       
//       return Path(path.cgPath)
//   }
//}
//
//extension Angle {
//   var radians: CGFloat {
//       return CGFloat(self.radians)
//   }
//}
//struct ContentView: View {
//   let options = ["Day", "Week", "Month"]
//   @State private var selectedOptionIndex = 0
//   @State private var showOptions = false
//   @State private var goal = ""
//   var body: some View {
//       VStack {
//           HStack {
//               Text("Goal:")
//               TextField("Enter your goal here", text: $goal)
//                   .textFieldStyle(RoundedBorderTextFieldStyle())
//     
//           
//               Button(action: {
//                   self.showOptions.toggle()
//               }) {
//                   HStack {
//                       Text(options[selectedOptionIndex])
//                       Image(systemName: "chevron.down")
//                           .rotationEffect(.degrees(showOptions ? 180 : 0))
//                           .animation(.easeInOut)
//                   } .frame(maxWidth: .infinity)
//                       .padding()
//                       .foregroundColor(.white)
//                       .background(Color.blue)
//                       .cornerRadius(10)
//                       .overlay(
//                           RoundedRectangle(cornerRadius: 10)
//                               .stroke(Color.blue, lineWidth: 2)
//                       )
//                       .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 3)
//                   
//               }
//               
//               if showOptions {
//                   Divider()
//                   
//                   VStack {
//                       ForEach(0..<options.count, id: \.self) { index in
//                           Button(action: {
//                               self.selectedOptionIndex = index
//                               self.showOptions.toggle()
//                           }) {
//                               Text(options[index])
//                           }
//                       }
//                   }  }
//           }
//       }
//       .padding()
//   }
//}
//
//struct ContentView_Previews: PreviewProvider {
//   static var previews: some View {
//       ContentView()
//   }
//}
