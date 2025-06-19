//
//  ProfileView.swift
//  MyCalories
//
//  Created by Иван Семикин on 11/05/2025.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var coordinator: Coordinator
    @StateObject var viewModel: ProfileViewModel
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                ForEach(PickerModalDisplay.allCases, id: \.rawValue) { item in
                    ProfileRowView(
                        title: item.rawValue,
                        value: viewModel.setPersonDataValues(for: item),
                        onTap: {
                            viewModel.selectedDisplay = item
                            viewModel.isPresentingPicker = true
                        }
                    )
                }
                
                Divider()
                
                Button {
                    withAnimation {
                        viewModel.savePersonData()
                    }
                } label: {
                    Text("Сохранить")
                        .customFont(font: .bold, color: .white)
                }
                .customCapsuleButton(
                    backgroundColor:
                        viewModel.saveButtonIsEnabled ? .colorApp : .gray
                )
                .disabled(!viewModel.saveButtonIsEnabled)
            }
            .padding()
            .background(BackgroundListView())
            .padding()
            
            RecommendedProgrammView()
                .environmentObject(viewModel)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BackgroundHeaderView(height: 80))
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarBackButton(title: "Главная", dismiss: coordinator.pop)
            
            ToolbarTitle(title: "Профиль")
        }
        .sheet(isPresented: $viewModel.isPresentingPicker) {
            ProfilePickerModalView()
                .environmentObject(viewModel)
            .presentationDetents([viewModel.selectedDisplay.preferredDetent])
        }
    }
}
