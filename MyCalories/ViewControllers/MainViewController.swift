//
//  MainViewController.swift
//  MyCalories
//
//  Created by Иван Семикин on 02/03/2024.
//

import UIKit

protocol MainViewControllerDelegate {
    func toggleMenu()
}

final class MainViewController: UIViewController {
    
    var delegate: MainViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Delegate in ViewDidLoad() in MainVC = \(delegate)")
        print("ViewDidLoad in MainVC was called")
    }

    @IBAction func menuBarButtonItemAction(_ sender: UIBarButtonItem) {
        delegate?.toggleMenu()
        print("Delegate in menuBarButtonAction() = \(delegate)")
//        print("Menu Tapped")
//        print(print("Delegate = \(delegate) from menuBarButtonItemAction in MainVC"))
    }
    
    deinit {
        print("\(type(of: self)) has been deellocated")
    }
}

