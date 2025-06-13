//
//  DatePickerSheet.swift
//  MyCalories
//
//  Created by Иван Семикин on 10/06/2025.
//

import SwiftUI

struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            DatePicker("Дата", selection: Binding(
                get: { selectedDate },
                set: { selectedDate = $0 }
            ), displayedComponents: .date)
            .datePickerStyle(.wheel)
            .labelsHidden()
            .padding()
            
            Button("Готово") {
                isPresented = false
            }
            .padding(.bottom)
        }
        .presentationDetents([.medium])
    }
}
