//
//  CreateNewProductView.swift
//  MyCalories
//
//  Created by Иван Семикин on 21/06/2025.
//

import SwiftUI

struct CreateNewProductView: View {
    @StateObject var viewModel: CreateNewProductViewModel
    @EnvironmentObject private var coordinator: Coordinator
    
    private var nutrientRows: [(String, Binding<String>)] {
        [
            ("Калории:",   $viewModel.calories),
            ("Белки:",     $viewModel.protein),
            ("Жиры:",      $viewModel.fats),
            ("Углеводы:",  $viewModel.carbohydrates)
        ]
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                TextField("Название продукта", text: $viewModel.name)
                    .padding(5)
                    .background(BackgroundListView(radius: 2))
                
                ForEach(nutrientRows, id: \.0) { title, binding in
                    LabelInputView(title: title, value: binding)
                }
                
                Text("на 100 г.")
                    .customFont(size: 15, color: .gray)
                
                Divider()
                
                Button {
                    viewModel.saveProduct()
                    coordinator.pop()
                } label: {
                    Text("Сохранить")
                        .customFont(font: .bold, color: .white)
                }
                .customCapsuleButton(backgroundColor: viewModel.isReadyForSave() ? .colorApp : .gray)
                .disabled(!viewModel.isReadyForSave())
            }
            .padding()
            .background(BackgroundListView())
            
            Spacer()
        }
        .padding()
        .background(BackgroundHeaderView(height: 80))
    }
}
