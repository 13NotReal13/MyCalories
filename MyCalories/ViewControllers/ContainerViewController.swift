//
//  ContainerViewController.swift
//  MyCalories
//
//  Created by Иван Семикин on 03/03/2024.
//

import UIKit

final class ContainerViewController: UIViewController, MainViewControllerDelegate {
    
    var controller: UIViewController!
    var menuViewController: UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureMainViewController()
    }
    
    func configureMainViewController() {
        let navigationVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? UINavigationController
        let mainVC = navigationVC?.viewControllers.first as? MainViewController
        
        mainVC?.delegate = self
        controller = mainVC
        view.addSubview(controller.view)
        addChild(controller)
    }

    func configureMenuViewController() {
        if menuViewController == nil {
            menuViewController = MenuViewController()
            view.insertSubview(menuViewController.view, at: 0)
            addChild(menuViewController)
            print("Added MainVC")
        }
    }
    
    // MARK: - MainViewControllerDelegate
    func toggleMenu() {
        configureMenuViewController()
        print("toggleMenu()")
    }
}
