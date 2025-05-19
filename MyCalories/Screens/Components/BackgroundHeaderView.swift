//
//  BackgroundHeaderView.swift
//  MyCalories
//
//  Created by Иван Семикин on 11/05/2025.
//

import SwiftUI

struct BackgroundHeaderView: View {
    let height: CGFloat
    
    var body: some View {
        VStack {
            Color.colorApp
                .roundedCorners(radius: 60, corners: [.bottomLeft, .bottomRight])
                .ignoresSafeArea()
                .frame(height: height)
            
            Spacer()
        }
    }
}

#Preview {
    BackgroundHeaderView(height: 140)
}
