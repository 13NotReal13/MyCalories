//
//  LabelChooseDateView.swift
//  MyCalories
//
//  Created by Иван Семикин on 19/06/2025.
//

import SwiftUI

struct LabelChooseDateView: View {
    let choosedDate: Date
    let action: () -> Void
    
    var body: some View {
        HStack {
            Text("Дата:")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                action()
            } label: {
                Text(Date.dateToString(choosedDate))
                .customFont(color: .black)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(5)
                .padding(.horizontal, 8)
                .background(BackgroundListView(radius: 2))
            }
        }
    }
}
