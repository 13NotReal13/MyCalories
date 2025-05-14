//
//  LeftMenuView.swift
//  MyCalories
//
//  Created by Иван Семикин on 10/05/2025.
//

import SwiftUI

enum MenuButton: String, CaseIterable {
    case main = "Главная"
    case profile = "Профиль"
    case history = "История"
    case settings = "Настройки"
    case rateApp = "Оценить приложение"
    case disableAds = "Отключить рекламу"
    case faq = "F.A.Q."
    
    var iconName: String {
        switch self {
        case .main:
            "line.3.horizontal"
        case .profile:
            "person"
        case .history:
            "clock.arrow.trianglehead.counterclockwise.rotate.90"
        case .settings:
            "gearshape"
        case .rateApp:
            "star"
        case .disableAds:
            "flame"
        case .faq:
            "info.circle"
        }
    }
}

struct LeftMenuView: View {
    @EnvironmentObject var coordinator: NavigationCoordinator
    @Binding var isMenuOpen: Bool
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color.black.opacity(isMenuOpen ? 0.4 : 0)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        isMenuOpen = false
                    }
                }
            
            ZStack {
                LeftMenuBackgroundView()
                
                LeftMenuButtonsView(isMenuOpen: $isMenuOpen)
            }
            .frame(width: 280)
            .offset(x: isMenuOpen ? 0 : -280)
        }
    }
}

struct LeftMenuButtonsView : View {
    @EnvironmentObject var coordinator: NavigationCoordinator
    @Binding var isMenuOpen: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(MenuButton.allCases, id: \.self) { button in
                Button {
                    isMenuOpen = false
                    
                    switch button {
                    case .main:
                        withAnimation {
                            isMenuOpen = false
                        }
                    case .profile:
                        coordinator.push(.profile)
                    default:
                        break
                    }
                } label: {
                    HStack {
                        Image(systemName: button.iconName)
                            .customFont(size: 24, color: .white)
                        
                        Text(button.rawValue)
                            .customFont(color: .white)
                    }
                    .padding(.vertical, 8)
                }
                
                RoundedRectangle(cornerRadius: 1)
                    .foregroundStyle(.white.opacity(0.4))
                    .frame(height: 1)
            }
            
            Spacer()
            
            if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                Text("Версия: \(appVersion) ")
                    .customFont(size: 11, color: .white)
            }
        }
        .padding(.horizontal)
        .padding(.top, 52)
        .ignoresSafeArea(edges: .top)

    }
}

struct LeftMenuBackgroundView: View {
    var body: some View {
        LinearGradient(
            colors: [
                .colorApp,
                .textColorApp
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .roundedCorners(corners: [.topRight, .bottomRight])
        .ignoresSafeArea(edges: .vertical)
        .shadow(color: .black.opacity(0.3), radius: 8)
    }
}

#Preview {
    LeftMenuView(isMenuOpen: .constant(true))
        .environmentObject(NavigationCoordinator.shared)
}
