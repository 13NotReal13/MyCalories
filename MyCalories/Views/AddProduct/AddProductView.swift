//
//  AddProductView.swift
//  MyCalories
//
//  Created by Иван Семикин on 09/06/2025.
//

import SwiftUI

struct AddProductView: View {
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var addProductViewModel: AddProductViewModel
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    coordinator.dismissSheet()
                } label: {
                    Text("Отмена")
                        .customFont(color: .white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Продукт")
                    .customFont(font: .bold, size: 19, color: .white)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
                    .frame(maxWidth: .infinity)
            }
            .padding(.bottom)
            
            VStack(spacing: 16) {
                
                Text(addProductViewModel.selectedProduct.name)
                    .customFont()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ProductRowView(
                    title: "Белки:",
                    per100g: addProductViewModel.selectedProduct.proteinToString,
                    perWeight: addProductViewModel.selectedProduct
                        .formattedBy(
                            weight: addProductViewModel.weight,
                            for: addProductViewModel.selectedProduct.protein
                        )
                )
                
                ProductRowView(
                    title: "Жиры:",
                    per100g: addProductViewModel.selectedProduct.fatsToString,
                    perWeight: addProductViewModel.selectedProduct
                        .formattedBy(
                            weight: addProductViewModel.weight,
                            for: addProductViewModel.selectedProduct.fats
                        )
                )
                
                ProductRowView(
                    title: "Углеводы:",
                    per100g: addProductViewModel.selectedProduct.carbohydratesToString,
                    perWeight: addProductViewModel.selectedProduct
                        .formattedBy(
                            weight: addProductViewModel.weight,
                            for: addProductViewModel.selectedProduct.carbohydrates
                        )
                )
                
                ProductRowView(
                    title: "Калории:",
                    per100g: addProductViewModel.selectedProduct.caloriesToString,
                    perWeight: addProductViewModel.selectedProduct
                        .formattedBy(
                            weight: addProductViewModel.weight,
                            for: addProductViewModel.selectedProduct.calories
                        )
                )
                
                HStack {
                    Text("")
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("на 100 г.")
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("на \(addProductViewModel.weight) г.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .customFont(size: 15, color: .gray)
                
                HStack {
                    Text("Вес продукта:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    TextField("г.", text: $addProductViewModel.weightText)
                        .keyboardType(.numberPad)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                        .padding(8)
                        .background(BackgroundListView(radius: 2))
                }
                
                HStack {
                    Text("Дата:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button {
                        addProductViewModel.isPresentingDatePicker = true
                    } label: {
                        Text(Date.dateToString(addProductViewModel.selectedDate))
                        .customFont(color: .black)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(5)
                        .padding(.horizontal, 8)
                        .background(BackgroundListView(radius: 2))
                    }
                }
                
                Divider()
                
                Button {
                    addProductViewModel.saveProductToHistory()
                    coordinator.dismissSheet()
                } label: {
                    Text("Добавить")
                        .customFont(font: .bold, color: .white)
                }
                .customCapsuleButton(backgroundColor: addProductViewModel.isReadyForAdd() ? .colorApp : .gray)
                .disabled(!addProductViewModel.isReadyForAdd())
            }
            .padding()
            .background(BackgroundListView())
            
            Spacer()
        }
        .padding()
        .background(BackgroundHeaderView(height: 130))
        .sheet(isPresented: $addProductViewModel.isPresentingDatePicker) {
            DatePickerSheet(
                selectedDate: $addProductViewModel.selectedDate,
                isPresented: $addProductViewModel.isPresentingDatePicker
            )
            .presentationDetents([.fraction(0.35)])
        }
    }
}

struct ProductRowView: View {
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

#Preview {
    NavigationStack {
        AddProductView(
            addProductViewModel: AddProductViewModel(realmManager: RealmManager(), selectedProduct: Product.fake(name: ""))
        )
    }
}
