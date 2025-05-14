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
    
    @State private var gender: String = ""
    @State private var dateOfBirth: Date = Date()
    @State private var height: String = ""
    @State private var weight: String = ""
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                ProfileRowView(
                    title: "Пол",
                    value: gender) {
                        
                    }
                
                ProfileRowView(
                    title: "Дата Рождения:",
                    value: gender) {
                        
                    }
                
                ProfileRowView(
                    title: "Рост:",
                    value: gender) {
                        
                    }
                
                ProfileRowView(
                    title: "Вес:",
                    value: gender) {
                        
                    }
                
                ProfileRowView(
                    title: "Активность:",
                    value: gender) {
                        
                    }
                
                ProfileRowView(
                    title: "Цель:",
                    value: gender) {
                        
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
        .background(BackgroundHeaderView(height: 120))
    }
}

#Preview {
    ProfileView()
        .environmentObject(NavigationCoordinator.shared)
}
