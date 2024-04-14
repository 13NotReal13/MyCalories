//
//  ViewController.swift
//  MyCalories
//
//  Created by Иван Семикин on 01/04/2024.
//

import UIKit
import RealmSwift

final class MainViewController: UIViewController {
    
    @IBOutlet var menuView: UIView!
    @IBOutlet var menuLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var menuTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var progressView: UIView!
    @IBOutlet var searchBar: UISearchBar!
    
    // MARK: - Private Properties
    private let storageManager = StorageManager.shared
    
    private var products: Results<Product>!
    private var filteredProducts: Results<Product>!
    
    private var menuIsVisible = false
    private var overlayView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        createProgressBar()
        addOverlayView()
        roundMenuCorners()
        
        storageManager.fetchProductsFromProjectRealm { [unowned self] productsList in
            products = productsList
            filteredProducts = products
            tableView.reloadData()
        }
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if menuIsVisible {
            toogleMenu()
        }
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
    func roundMenuCorners() {
        // Создаем маску для скругления углов
        let maskLayer = CAShapeLayer()
        maskLayer.frame = menuView.bounds
        
        // Создаем путь для скругления углов
        let roundedRect = CGRect(
            origin: CGPoint(x: 0, y: 0),
            size: CGSize(width: menuView.bounds.width, height: menuView.bounds.height)
        )
        let path = UIBezierPath(
            roundedRect: roundedRect,
            byRoundingCorners: [.topRight, .bottomRight],
            cornerRadii: CGSize(width: 20, height: 20) // Радиус скругления
        )
        maskLayer.path = path.cgPath
        
        // Устанавливаем маску для меню
        menuView.layer.mask = maskLayer
    }
    
    private func toogleMenu() {
        UIView.animate(withDuration: 0.3) { [unowned self] in
            if menuIsVisible {
                menuLeadingConstraint.constant = -menuView.frame.size.width
                menuTrailingConstraint.constant = view.frame.width
                overlayView.alpha = 0
            } else {
                menuLeadingConstraint.constant = 0
                menuTrailingConstraint.constant = 80
                overlayView.alpha = 1
            }
            view.layoutIfNeeded()
        }
        
        menuIsVisible.toggle()
    }
    
    func addOverlayView() {
        overlayView = UIView(frame: view.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlayView.alpha = 0
        view.addSubview(overlayView)
        view.bringSubviewToFront(overlayView)
        view.bringSubviewToFront(menuView)
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
    
    @objc func doneButtonPressed() {
        searchBar.resignFirstResponder()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "productsCell",
            for: indexPath
        ) as? ProductsListViewCell
        
        let product = filteredProducts[indexPath.row]
        cell?.productNameLabel.text = product.name
        cell?.productNameLabel.textColor = UIColor(named: product.color)
        cell?.proteinProductLabel.text = "БЕЛКИ: \(product.protein)"
        cell?.fatsProductLabel.text = "ЖИРЫ: \(product.fats)"
        cell?.carbohydratesProductLabel.text = "УГЛЕВОДЫ: \(product.carbohydrates)"
        cell?.caloriesProductLabel.text = "ККАЛ: \(product.calories) НА 100 Г."
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let predicate = NSPredicate(format: "name CONTAINS[c] %@", searchText)
        filteredProducts = searchText.isEmpty ? products : products.filter(predicate)
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(
            title: "Готово",
            style: .done,
            target: self,
            action: #selector(doneButtonPressed)
        )
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        keyboardToolbar.setItems([flexButton, doneButton], animated: true)
        searchBar.inputAccessoryView = keyboardToolbar
    }
}
