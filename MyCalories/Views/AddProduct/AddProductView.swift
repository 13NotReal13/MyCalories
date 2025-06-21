//
//  AddProductView.swift
//  MyCalories
//
//  Created by Иван Семикин on 09/06/2025.
//

import SwiftUI

struct AddProductView: View {
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var viewModel: AddProductViewModel
    
    private var nutrientRows: [(String, Double)] {
        [
            ("Калории:", viewModel.selectedProduct.calories),
            ("Белки:", viewModel.selectedProduct.protein),
            ("Жиры:", viewModel.selectedProduct.fats),
            ("Углеводы:", viewModel.selectedProduct.carbohydrates)
        ]
    }
    
    var body: some View {
        VStack {
            SheetHeaderView(title: "Продукт", onDismiss: coordinator.dismissSheet)
            
            VStack(spacing: 16) {
                
                Text(viewModel.selectedProduct.name)
                    .customFont()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ForEach(nutrientRows, id: \.0) { title, value in
                    NutrientRowView(
                        title: title,
                        per100g: value.formatted(.number.precision(.fractionLength(2))),
                        perWeight: viewModel.selectedProduct.formattedBy(weight: viewModel.weight, for: value)
                    )
                }
                
                HStack {
                    Text("")
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("на 100 г.")
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("на \(viewModel.weight) г.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .customFont(size: 15, color: .gray)
                
                Divider()
                
                LabelInputView(title: "Вес продукта:", value: $viewModel.weightText)
                
                LabelChooseDateView(choosedDate: viewModel.selectedDate) {
                    viewModel.isPresentingDatePicker = true
                }
                
                Divider()
                
                Button {
                    viewModel.saveProductToHistory()
                    coordinator.dismissSheet()
                } label: {
                    Text("Добавить")
                        .customFont(font: .bold, color: .white)
                }
                .customCapsuleButton(backgroundColor: viewModel.isReadyForAdd() ? .colorApp : .gray)
                .disabled(!viewModel.isReadyForAdd())
            }
            .padding()
            .background(BackgroundListView())
            
            Spacer()
        }
        .padding()
        .background(BackgroundHeaderView(height: 130))
        .sheet(isPresented: $viewModel.isPresentingDatePicker) {
            DatePickerSheet(
                selectedDate: $viewModel.selectedDate,
                isPresented: $viewModel.isPresentingDatePicker
            )
            .presentationDetents([.fraction(0.35)])
        }
    }
}

struct NutrientRowView: View {
    let title: String
    let per100g: String
    let perWeight: String
    
    var body: some View {
        HStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("\(per100g) г.")
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("\(perWeight) г.")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .customFont(color: .gray)
    }
}
