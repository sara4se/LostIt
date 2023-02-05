//
//  CustomCorner.swift
//  Dalti
//
//  Created by Sara Alhumidi on 14/07/1444 AH.
//

import SwiftUI

struct CustomCorner : Shape{
    var corners : UIRectCorner
    var radius : CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
