//
//  ViewController.swift
//  MyCalories
//
//  Created by Иван Семикин on 01/04/2024.
//

import UIKit

final class MainViewController: UIViewController {
    
    @IBOutlet var menuView: UIView!
    @IBOutlet var menuLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var menuTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet var progressView: UIView!
    
    private var menuIsVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuView.layer.cornerRadius = 20
        setupNavigationBar()
        createProgressBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        menuLeadingConstraint.constant = -menuView.frame.size.width
        menuTrailingConstraint.constant = view.frame.width
        view.layoutIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        toogleMenu()
    }
    
    @IBAction func menuUIButtonAction() {
        toogleMenu()
    }
    
    @IBAction func menuBarButtonItemAction(_ sender: UIBarButtonItem) {
        toogleMenu()
    }
    
}

// MARK: - Private Methods
private extension MainViewController {
    private func toogleMenu() {
        UIView.animate(withDuration: 0.3) { [unowned self] in
            if menuIsVisible {
                menuLeadingConstraint.constant = -menuView.frame.size.width
                menuTrailingConstraint.constant = view.frame.width
            } else {
                menuLeadingConstraint.constant = 0
                menuTrailingConstraint.constant = 80
            }
            view.layoutIfNeeded()
        }
        
        menuIsVisible.toggle()
    }
    
    func setupNavigationBar() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = .colorApp
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.tintColor = .white
    }
    
    func createProgressBar() {
        let midWidth = Int(view.frame.width / 2)
        let frameY = Int(progressView.frame.height / 2 - 40)
        
        let proteinProgress = CircularProgressBar(
            frame: CGRect(
                x: midWidth - 171,
                y: frameY,
                width: 55,
                height: 55
            ),
            progressColor: .green
        )
        
        let fatsProgress = CircularProgressBar(
            frame: CGRect(
                x: midWidth - 99,
                y: frameY,
                width: 55,
                height: 55
            ),
            progressColor: .orange
        )
        
        let carbohydratesProgress = CircularProgressBar(
            frame: CGRect(
                x: midWidth - 27,
                y: frameY,
                width: 55,
                height: 55
            ),
            progressColor: .cyan
        )
        
        let caloriesProgress = CircularProgressBar(
            frame: CGRect(
                x: midWidth + 45,
                y: frameY,
                width: 55,
                height: 55
            ),
            progressColor: .yellow
        )
        
        let waterProgress = CircularProgressBar(
            frame: CGRect(
                x: midWidth + 117,
                y: frameY,
                width: 55,
                height: 55
            ),
            progressColor: .blue
        )
        
        progressView.addSubview(proteinProgress)
        progressView.addSubview(fatsProgress)
        progressView.addSubview(carbohydratesProgress)
        progressView.addSubview(caloriesProgress)
        progressView.addSubview(waterProgress)
        
        // Set Progress
        proteinProgress.progress = 0.51
        fatsProgress.progress = 0.64
        carbohydratesProgress.progress = 0.71
        caloriesProgress.progress = 0.51
        waterProgress.progress = 0.87
    }
}
