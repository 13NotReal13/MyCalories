//
//  ProfileView.swift
//  MyCalories
//
//  Created by Иван Семикин on 11/05/2025.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @StateObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                ForEach(PickerModalDisplay.allCases, id: \.rawValue) { item in
                    ProfileRowView(
                        title: item.rawValue,
                        value: profileViewModel.setPersonDataValues(for: item),
                        onTap: {
                            profileViewModel.selectedDisplay = item
                            profileViewModel.isPresentingPicker = true
                        }
                    )
                }
                
                Divider()
                
                Button {
                    profileViewModel.savePersonData()
                } label: {
                    Text("Сохранить")
                        .customFont(font: .bold, color: .white)
                        .padding(.vertical, 12)
                        .frame(width: 150)
                        .background(Capsule().foregroundStyle(profileViewModel.saveButtonIsEnabled ? .colorApp : .gray))
                }
                .disabled(!profileViewModel.saveButtonIsEnabled)
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.3), radius: 8)
            }
            .padding()
            
            RecommendedProgrammView()
                .environmentObject(profileViewModel)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BackgroundHeaderView(height: 80))
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
        }
        .sheet(isPresented: $profileViewModel.isPresentingPicker) {
            ProfilePickerModalView()
                .environmentObject(profileViewModel)
            .presentationDetents([profileViewModel.selectedDisplay.preferredDetent])
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView(profileViewModel: ProfileViewModel(realmManager: RealmManager.shared))
            .environmentObject(NavigationCoordinator.shared)
    }
}
