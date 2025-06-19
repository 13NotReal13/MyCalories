//
//  SheetHeaderView.swift
//  MyCalories
//
//  Created by Иван Семикин on 19/06/2025.
//

import SwiftUI

struct SheetHeaderView: View {
    let title: String
    let onDismiss: () -> Void
    
    var body: some View {
        HStack {
            Button {
                onDismiss()
            } label: {
                Text("Отмена")
                    .customFont(color: .white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(title)
                .customFont(font: .bold, size: 19, color: .white)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
                .frame(maxWidth: .infinity)
        }
        .padding(.bottom)
    }
}
