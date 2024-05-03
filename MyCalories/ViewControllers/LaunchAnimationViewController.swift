//
//  LaunchAnimationViewController.swift
//  MyCalories
//
//  Created by Иван Семикин on 03/05/2024.
//

import Foundation
import UIKit

class LaunchAnimationViewController: UIViewController {
    let logoImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLogo()
        animateLogo()
    }

    private func setupLogo() {
        // Предполагается, что logo.png — это ваше изображение
        logoImageView.image = UIImage(named: "logo.png")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.frame = CGRect(x: -100, y: view.bounds.midY - 50, width: 100, height: 100)
        view.addSubview(logoImageView)
    }

    private func animateLogo() {
        // Анимация "выпрыгивания" из левой части экрана
        UIView.animate(withDuration: 0.5, animations: {
            self.logoImageView.center.x = self.view.bounds.midX
        }, completion: { _ in
            // Прыжок вверх и падение за экран
            UIView.animate(withDuration: 0.25, animations: {
                self.logoImageView.center.y -= 30
            }, completion: { _ in
                UIView.animate(withDuration: 0.35, animations: {
                    self.logoImageView.center.y = self.view.bounds.maxY + 100
                }, completion: { _ in
                    self.openMainScreen()
                })
            })
        })
    }

    private func openMainScreen() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
            let mainViewController = MainViewController() // Замените на ваш основной ViewController
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                window.rootViewController = mainViewController
            })
        }
    }
}

