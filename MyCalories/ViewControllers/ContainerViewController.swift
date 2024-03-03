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
        print("ViewDidLoad in ContainerVC was called")
    }
    
    func configureMainViewController() {
        let navigationVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? UINavigationController
        let mainVC = navigationVC?.viewControllers.first as? MainViewController
        
        mainVC?.delegate = self
        controller = mainVC
        view.addSubview(controller.view)
        addChild(controller)
        print("Delegate in CongigVC() = \(mainVC?.delegate)")
        print("configureMainViewController() was called")
    }

    func configureMenuViewController() {
        if menuViewController == nil {
            menuViewController = MenuViewController()
            view.insertSubview(menuViewController.view, at: 0)
            addChild(menuViewController)
            print("configureMenuViewController() was called")
        }
    }
    
    // MARK: - MainViewControllerDelegate
    func toggleMenu() {
        configureMenuViewController()
        print("toggleMenu() was called")
    }
    
    deinit {
        print("\(type(of: self)) has been deellocated")
    }
}
