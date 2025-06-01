//
//  ProfileView.swift
//  MyCalories
//
//  Created by Иван Семикин on 11/05/2025.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @StateObject private var profileViewModel = ProfileViewModel.shared
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                ForEach(PickerModalDisplay.allCases, id: \.rawValue) { item in
                    ProfileRowView(
                        title: item.rawValue,
                        value: profileViewModel.setValue(for: item),
                        onTap: {
                            profileViewModel.selectedDisplay = item
                            profileViewModel.isPresentingPicker = true
                        }
                    )
                }
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.3), radius: 8)
            }
            .padding()
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BackgroundHeaderView(height: 100))
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                NavigationBackButtonView(
                    title: "Главная",
                    dismiss: coordinator.pop
                )
            }
            
            ToolbarItem(placement: .principal) {
                Text("Профиль")
                    .customFont(font: .bold, size: 19, color: .white)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    profileViewModel.savePersonData()
                } label: {
                    Text("Сохранить")
                        .customFont(color: profileViewModel.saveButtonIsEnabled ? .white : .white.opacity(0.6))
                }
                .disabled(!profileViewModel.saveButtonIsEnabled)
            }
        }
        .sheet(isPresented: $profileViewModel.isPresentingPicker) {
            ProfilePickerModalView(
                display: profileViewModel.selectedDisplay,
                gender: $profileViewModel.gender,
                dateBirth: $profileViewModel.dateOfBirthday,
                height: $profileViewModel.height,
                weight: $profileViewModel.weight,
                activityLevel: $profileViewModel.activityLevel,
                goal: $profileViewModel.goal
            )
            .presentationDetents([profileViewModel.selectedDisplay.preferredDetent])
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
            .environmentObject(NavigationCoordinator.shared)
    }
}
