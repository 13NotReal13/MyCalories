//
//  ViewController.swift
//  MyCalories
//
//  Created by Иван Семикин on 01/04/2024.
//

import UIKit
import RealmSwift

protocol MainScreenDelegate: AnyObject {
    func updateProgressBar()
    func setHiddenOfProgressBlock()
    func updateTableView()
}

final class MainViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var menuView: UIView!
    @IBOutlet var menuLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var menuTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var waterButton: UIButton!
    
    @IBOutlet var extendingNavigationBarView: UIView!
    @IBOutlet var shadowForTableViewView: UIView!
    @IBOutlet var shadowForProgressBarView: UIView!
    @IBOutlet var progressView: UIView!
    @IBOutlet var progressIsBlock: UIView!
    
    @IBOutlet var proteinTodayLabel: UILabel!
    @IBOutlet var proteinProgrammLabel: UILabel!
    
    @IBOutlet var fatsTodayLabel: UILabel!
    @IBOutlet var fatsProgrammLabel: UILabel!
    
    @IBOutlet var carbohydratesTodayLabel: UILabel!
    @IBOutlet var carbohydratesProgrammLabel: UILabel!
    
    @IBOutlet var caloriesTodayLabel: UILabel!
    @IBOutlet var caloriesProgrammLabel: UILabel!
    
    @IBOutlet var waterTodayLabel: UILabel!
    @IBOutlet var waterProgrammLabel: UILabel!
    
    // MARK: - Private Properties
    private let storageManager = StorageManager.shared
    
    private var allProducts: Results<Product>!
    private var filteredProducts: Results<Product>!
    
    private var menuIsVisible = false
    
    private var proteinProgressBar: CircularProgressBar?
    private var fatsProgressBar: CircularProgressBar?
    private var carbohydratesProgressBar: CircularProgressBar?
    private var caloriesProgressBar: CircularProgressBar?
    private var waterProgressBar: CircularProgressBar?
    
    private lazy var overlayView: UIView = {
        let overlay = UIView(frame: view.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlay.alpha = 0
        return overlay
    }()
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setupForegroundNotification()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupRoundedCornersForViews()
        searchBar.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        menuLeadingConstraint.constant = -menuView.frame.size.width
        menuTrailingConstraint.constant = view.frame.width
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "SegueToProfileVC":
            if let profileVC = segue.destination as? ProfileViewController {
                profileVC.delegate = self
            }
        case "SegueToHistoryProductsVC":
            if let historyProductsVC = segue.destination as? HistroryProductsViewController {
                historyProductsVC.delegate = self
            }
        case "SegueToSettingsVC":
            if let settingsVC = segue.destination as? SettingsViewController {
                settingsVC.delegate = self
            }
        case "SegueToAddProductToHistoryVC":
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            guard let navigationVC = segue.destination as? UINavigationController else { return }
            guard let usedProductVC = navigationVC.topViewController as? AddProductToHistoryViewController else { return }
            let product = filteredProducts[indexPath.row]
            usedProductVC.selectedProduct = product
            
            usedProductVC.delegate = self
        case "SegueToAddNewProductVC":
            guard let navigationVC = segue.destination as? UINavigationController else { return }
            guard let addNewProductVC = navigationVC.topViewController as? AddNewProductViewController else { return }
            addNewProductVC.delegate = self
        default:
            return
        }
    }
    
    @IBAction func menuUIButtonAction() {
        toogleMenu()
    }
    
    @IBAction func menuBarButtonItemAction(_ sender: UIBarButtonItem) {
        toogleMenu()
    }
    
    @IBAction func waterButtonAction() {
        showAlertForAddWater()
    }
    
    // Выход из фонового режима и обновление данных в прогресс баре
    private func setupForegroundNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func appWillEnterForeground() {
        updateProgressBar()
    }
}

// MARK: - MainScreenDelegate
extension MainViewController: MainScreenDelegate {
    func updateProgressBar() {
        setProgressBarValues()
    }
    
    func setHiddenOfProgressBlock() {
        if storageManager.fetchPerson() != nil {
            progressIsBlock.isHidden = true
        }
    }
    
    func updateTableView() {
        searchBar.searchTextField.resignFirstResponder()
        tableView.reloadData()
    }
}

// MARK: - Private Methods
private extension MainViewController {
    func initialSetup() {
        fetchData()
        setupUIs()
        setHiddenOfProgressBlock()
        initializeProgressBars()
        setProgressBarValues()
    }
    
    func fetchData() {
        storageManager.fetchAllProducts { [unowned self] productsList in
            allProducts = productsList
            filteredProducts = allProducts
            tableView.reloadData()
        }
    }
    
    func setupUIs() {
        // Navigation Bar
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = .colorApp
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.shadowColor = nil
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.tintColor = .white
        
        // MenuView + OverlayView
        menuView.roundCorners(corners: [.topRight, .bottomRight], radius: 20)
        view.addSubview(overlayView)
        view.bringSubviewToFront(overlayView)
        view.bringSubviewToFront(menuView)
        
        // SearchBar Color
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor.white // Установите нужный цвет
        }
        
        // Shadows for Views
        shadowForTableViewView.layer.cornerRadius = 15
        shadowForTableViewView.layer.shadowColor = UIColor.black.cgColor
        shadowForTableViewView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowForTableViewView.layer.shadowRadius = 6
        shadowForTableViewView.layer.shadowOpacity = 0.3
        shadowForTableViewView.clipsToBounds = false
        shadowForTableViewView.layer.masksToBounds = false
        
        shadowForProgressBarView.layer.cornerRadius = 40
        shadowForProgressBarView.layer.shadowColor = UIColor.black.cgColor
        shadowForProgressBarView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowForProgressBarView.layer.shadowRadius = 6
        shadowForProgressBarView.layer.shadowOpacity = 0.6
        shadowForProgressBarView.clipsToBounds = false
        shadowForProgressBarView.layer.masksToBounds = false
        
        waterButton.layer.shadowColor = UIColor.black.cgColor
        waterButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        waterButton.layer.shadowRadius = 3
        waterButton.layer.shadowOpacity = 0.1
        waterButton.clipsToBounds = false
        waterButton.layer.masksToBounds = false
    }
    
    func setupRoundCornersForProgressIsBlock() {
        let maskPath = UIBezierPath(roundedRect: progressIsBlock.bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: 35, height: 35))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        progressIsBlock.layer.mask = shape
        progressIsBlock.layer.masksToBounds = true
    }
    
    func setupRoundedCornersForViews() {
        menuView.roundCorners(corners: [.topRight, .bottomRight], radius: 20)
        
        let maskPathNavigationBar = UIBezierPath(roundedRect: extendingNavigationBarView.bounds,
                                    byRoundingCorners: [.bottomLeft, .bottomRight],
                                    cornerRadii: CGSize(width: 50, height: 50))
        let shapeNavigationBar = CAShapeLayer()
        shapeNavigationBar.path = maskPathNavigationBar.cgPath
        extendingNavigationBarView.layer.mask = shapeNavigationBar
        extendingNavigationBarView.layer.masksToBounds = true
        
        let maskPathProgressIsBlock = UIBezierPath(roundedRect: progressIsBlock.bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: 35, height: 35))
        let shapeProgressIsBlock = CAShapeLayer()
        shapeProgressIsBlock.path = maskPathProgressIsBlock.cgPath
        progressIsBlock.layer.mask = shapeProgressIsBlock
        progressIsBlock.layer.masksToBounds = true
    }
    
    func toogleMenu() {
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
    
    func showAlertForAddWater() {
        let alert = UIAlertController(
            title: "Сколько воды вы выпили?",
            message: "",
            preferredStyle: .alert
        )
        
        let okButton = UIAlertAction(title: "Сохранить", style: .default) { [unowned self] _ in
            guard let text = alert.textFields?.first?.text, let waterML = Int(text) else { return }
            let water = Water()
            water.date = Date()
            water.ml = waterML
            storageManager.saveWaterToHistory(water) { [unowned self] in
                setProgressBarValues()
            }
        }
        let cancelButton = UIAlertAction(title: "Отмена", style: .destructive)
        
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        alert.addTextField { textField in
            textField.placeholder = "мл."
            textField.keyboardType = .numberPad
        }
        present(alert, animated: true)
    }
    
    func showAlertForDeletingProduct(_ product: Product, indexPath: IndexPath) {
        let alert = UIAlertController(title: "Вы уверены, что хотите удалить?", message: product.name, preferredStyle: .alert)
        
        let deleteButton = UIAlertAction(title: "Удалить", style: .destructive) { [unowned self] _ in
            storageManager.deleteProduct(product) { [unowned self] in
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        
        let cancelButton = UIAlertAction(title: "Отмена", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(deleteButton)
        alert.addAction(cancelButton)
        present(alert, animated: true)
    }
    
    @objc func doneButtonPressed() {
        searchBar.resignFirstResponder()
    }
    
}

// MARK: - Progress Bar
private extension MainViewController {
    func createCircularProgress(xOffset: Int, color: UIColor, initialProgress: CGFloat) -> CircularProgressBar {
        let midWidth = Int(view.frame.width / 2)
        let frameY = Int(progressView.frame.height / 2 - 45)
        let progressBar = CircularProgressBar(
            frame: CGRect(
                x: midWidth + xOffset,
                y: frameY,
                width: 55,
                height: 55
            ),
            progressColor: color
        )
        progressBar.progress = initialProgress
        return progressBar
    }
    
    func initializeProgressBars() {
        proteinProgressBar = createCircularProgress(xOffset: -171, color: .white, initialProgress: 0.0)
        proteinProgressBar?.layer.shadowColor = UIColor.white.cgColor
        proteinProgressBar?.layer.shadowOffset = CGSize(width: 0, height: 0)
        proteinProgressBar?.layer.shadowRadius = 2
        proteinProgressBar?.layer.shadowOpacity = 0.8
        proteinProgressBar?.clipsToBounds = false
        proteinProgressBar?.layer.masksToBounds = false
        
        fatsProgressBar = createCircularProgress(xOffset: -99, color: .systemOrange, initialProgress: 0.0)
        fatsProgressBar?.layer.shadowColor = UIColor.systemOrange.cgColor // systemOrange
        fatsProgressBar?.layer.shadowOffset = CGSize(width: 0, height: 0)
        fatsProgressBar?.layer.shadowRadius = 2
        fatsProgressBar?.layer.shadowOpacity = 0.8
        fatsProgressBar?.clipsToBounds = false
        fatsProgressBar?.layer.masksToBounds = false
        
        carbohydratesProgressBar = createCircularProgress(xOffset: -27, color: .cyan, initialProgress: 0.0)
        carbohydratesProgressBar?.layer.shadowColor = UIColor.cyan.cgColor
        carbohydratesProgressBar?.layer.shadowOffset = CGSize(width: 0, height: 0)
        carbohydratesProgressBar?.layer.shadowRadius = 2
        carbohydratesProgressBar?.layer.shadowOpacity = 0.8
        carbohydratesProgressBar?.clipsToBounds = false
        carbohydratesProgressBar?.layer.masksToBounds = false
        
        caloriesProgressBar = createCircularProgress(xOffset: 45, color: .yellow, initialProgress: 0.0)
        caloriesProgressBar?.layer.shadowColor = UIColor.yellow.cgColor
        caloriesProgressBar?.layer.shadowOffset = CGSize(width: 0, height: 0)
        caloriesProgressBar?.layer.shadowRadius = 2
        caloriesProgressBar?.layer.shadowOpacity = 0.8
        caloriesProgressBar?.clipsToBounds = false
        caloriesProgressBar?.layer.masksToBounds = false
        
        waterProgressBar = createCircularProgress(xOffset: 117, color: .blue, initialProgress: 0.0)
        waterProgressBar?.layer.shadowColor = UIColor.blue.cgColor
        waterProgressBar?.layer.shadowOffset = CGSize(width: 0, height: 0)
        waterProgressBar?.layer.shadowRadius = 2
        waterProgressBar?.layer.shadowOpacity = 0.8
        waterProgressBar?.clipsToBounds = false
        waterProgressBar?.layer.masksToBounds = false
        
        [proteinProgressBar, fatsProgressBar, carbohydratesProgressBar, caloriesProgressBar, waterProgressBar].compactMap { $0 }.forEach {
            progressView.addSubview($0)
        }
    }
    
    func setProgressBarValues() {
        guard let recommendedProgramm = storageManager.fetchRecommendedProgramm() else { return }
        
        let settings = storageManager.fetchSettings()
        let userProgramm = storageManager.fetchUserProgramm()
        let allTodayTotalNutritions = storageManager.fetchTodayTotalNutrients()
        
        let proteinToday = allTodayTotalNutritions.proteins
        let fatsToday = allTodayTotalNutritions.fats
        let carbohydratesToday = allTodayTotalNutritions.carbohydrates
        let caloriesToday = allTodayTotalNutritions.calories
        let waterToday = allTodayTotalNutritions.water
        
        let proteinProgramm = settings.bguEnabled ? recommendedProgramm.proteins : userProgramm.proteins
        let fatsProgramm = settings.bguEnabled ? recommendedProgramm.fats : userProgramm.fats
        let carbohydratesProgramm = settings.bguEnabled ? recommendedProgramm.carbohydrates : userProgramm.carbohydrates
        let caloriesProgramm = settings.caloriesEnabled ? recommendedProgramm.calories : userProgramm.calories
        let waterProgramm = settings.waterEnabled ? recommendedProgramm.water : userProgramm.water
        
        proteinProgressBar?.progress = proteinToday < proteinProgramm
            ? Double(proteinToday) / Double(proteinProgramm)
            : 1.0
        fatsProgressBar?.progress = fatsToday < fatsProgramm
            ? Double(fatsToday) / Double(fatsProgramm )
            : 1.0
        carbohydratesProgressBar?.progress = carbohydratesToday < carbohydratesProgramm
            ? Double(carbohydratesToday) / Double(carbohydratesProgramm)
            : 1.0
        caloriesProgressBar?.progress = caloriesToday < caloriesProgramm
            ? Double(caloriesToday) / Double(caloriesProgramm)
            : 1.0
        waterProgressBar?.progress = waterToday < waterProgramm
            ? Double(waterToday) / Double(waterProgramm)
            : 1.0
        
        proteinTodayLabel.text = proteinToday > proteinProgramm
            ? "\(proteinToday.formatted()) !"
            : proteinToday.formatted()
        proteinTodayLabel.textColor = proteinToday > proteinProgramm ? .yellow : .white
        
        fatsTodayLabel.text = fatsToday > fatsProgramm
            ? "\(fatsToday.formatted()) !"
            : fatsToday.formatted()
        fatsTodayLabel.textColor = fatsToday > fatsProgramm ? .yellow : .white
        
        carbohydratesTodayLabel.text = carbohydratesToday > carbohydratesProgramm
            ? "\(carbohydratesToday.formatted()) !"
            : carbohydratesToday.formatted()
        carbohydratesTodayLabel.textColor = carbohydratesToday > carbohydratesProgramm ? .yellow : .white
        
        caloriesTodayLabel.text = caloriesToday > caloriesProgramm
            ? "\(caloriesToday.formatted()) !"
            : caloriesToday.formatted()
        caloriesTodayLabel.textColor = caloriesToday > caloriesProgramm ? .yellow : .white
        
        waterTodayLabel.text = waterToday > waterProgramm
            ? "\(waterToday.formatted()) !"
            : waterToday.formatted()
        waterTodayLabel.textColor = waterToday > waterProgramm ? .yellow : .white
    
        proteinProgrammLabel.text = proteinProgramm.formatted()
        fatsProgrammLabel.text = fatsProgramm.formatted()
        carbohydratesProgrammLabel.text = carbohydratesProgramm.formatted()
        caloriesProgrammLabel.text = caloriesProgramm.formatted()
        waterProgrammLabel.text = waterProgramm.formatted()
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let product = filteredProducts[indexPath.row]
        
        let deleteButton = UIContextualAction(style: .normal, title: "Удалить") { [unowned self] _, _, isDone in
            showAlertForDeletingProduct(product, indexPath: indexPath)
            isDone(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteButton])
    }
}

// MARK: - UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredProducts = searchText.isEmpty ? allProducts : allProducts.filter("name CONTAINS[c] %@", searchText)
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
