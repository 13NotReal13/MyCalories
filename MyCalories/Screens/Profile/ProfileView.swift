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
    @State private var segmentedTab = 0
    
    @State private var gender: Gender = .male
    @State private var dateBirth: Date = Date()
    @State private var height: Double = 170
    @State private var weight: (kg: Double, gramm: Double) = (0, 0)
    @State private var activityLevel: Activity = .low
    @State private var goal: Goal = .downWeight
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                ForEach(PickerModalDisplay.allCases, id: \.rawValue) { item in
                    ProfileRowView(
                        title: item.rawValue,
                        value: "",
                        onTap: { coordinator.presentModal(.profilePicker(display: item)) }
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
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
            .environmentObject(NavigationCoordinator.shared)
    }
}
