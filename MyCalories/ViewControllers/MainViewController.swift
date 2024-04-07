//
//  ViewController.swift
//  MyCalories
//
//  Created by Иван Семикин on 01/04/2024.
//

import UIKit

final class MainViewController: UIViewController {
    
    @IBOutlet var progressView: UIView!
    private var progressLabel = UILabel()
    
    @IBOutlet var menuView: UIView!
    @IBOutlet var menuLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var menuTrailingConstraint: NSLayoutConstraint!
    
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
    
    func createProgressBar() {
        let widthOfView = view.frame.width
        
        let circularProgressBar = CircularProgressBar(
            frame: CGRect(
                x: widthOfView / 2 - 27,
                y: progressView.frame.height / 2 - 40,
                width: 55,
                height: 55
            ),
            progressColor: .cyan
        )
        circularProgressBar.progress = 0.62 // Пример значения прогресса
        progressView.addSubview(circularProgressBar)

        
        let circularProgressBarTwo = CircularProgressBar(
            frame: CGRect(
                x: circularProgressBar.frame.minX - widthOfView / 5 + 5,
                y: progressView.frame.height / 2 - 40,
                width: 55,
                height: 55
            ),
            progressColor: .brown
        )
        circularProgressBarTwo.progress = 0.48 // Пример значения прогресса
        progressView.addSubview(circularProgressBarTwo)
        
        let circularProgressBarThree = CircularProgressBar(
            frame: CGRect(
                x: circularProgressBarTwo.frame.minX - widthOfView / 5 + 5,
                y: progressView.frame.height / 2 - 40,
                width: 55,
                height: 55
            ),
            progressColor: .yellow
        )
        circularProgressBarThree.progress = 0.51 // Пример значения прогресса
        progressView.addSubview(circularProgressBarThree)
        
        let circularProgressBarFour = CircularProgressBar(
            frame: CGRect(
                x: circularProgressBar.frame.minX + widthOfView / 5 - 5,
                y: progressView.frame.height / 2 - 40,
                width: 55,
                height: 55
            ),
            progressColor: .magenta
        )
        circularProgressBarFour.progress = 0.52 // Пример значения прогресса
        progressView.addSubview(circularProgressBarFour)
        
        let circularProgressBarFive = CircularProgressBar(
            frame: CGRect(
                x: circularProgressBarFour.frame.minX + widthOfView / 5 - 5,
                y: progressView.frame.height / 2 - 40,
                width: 55,
                height: 55
            ),
            progressColor: .systemBlue
        )
        circularProgressBarFive.progress = 0.83 // Пример значения прогресса
        progressView.addSubview(circularProgressBarFive)
    }

}

private extension MainViewController {
    func setupNavigationBar() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = .colorApp
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.tintColor = .white
    }
}
