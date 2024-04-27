//
//  ViewController.swift
//  MyCalories
//
//  Created by Иван Семикин on 01/04/2024.
//

import UIKit
import RealmSwift

protocol MainScreenDelegate: AnyObject {
    func setProgressBarValues()
}

final class MainViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var menuView: UIView!
    @IBOutlet var menuLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var menuTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var progressView: UIView!
    @IBOutlet var progressIsBlock: UIView!
    @IBOutlet var searchBar: UISearchBar!
    
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
    
    private var allProducts: [Product] = []
    private var filteredProducts: [Product] = []
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
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
            if let addNewProductVC = segue.destination as? AddNewProductViewController {
                addNewProductVC.delegate = self
            }
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
        showAlert()
    }
    
    // Выход из фонового режима и обновление данных в прогресс баре
    private func setupForegroundNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func appWillEnterForeground() {
        setProgressBarValues()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Private Methods
private extension MainViewController {
    func initialSetup() {
        fetchData()
        setupNavigationBar()
        initializeProgressBars()
        setProgressBarValues()
        setupOverlayView()
        roundMenuCorners()
    }
    
    func fetchData() {
        storageManager.fetchUsedProducts { [unowned self] usedProducts in
            usedProducts.forEach { allProducts.append($0) }
            
            storageManager.fetchProjectProducts { [unowned self] projectProducts in
                // Фильтруем projectProducts, чтобы оставить только те продукты, которых нет в allProducts
                let newProjectProducts = projectProducts.filter { projectProduct in
                    !allProducts.contains { $0.name == projectProduct.name }
                }
                allProducts.append(contentsOf: newProjectProducts)
                
                filteredProducts = allProducts
                tableView.reloadData()
            }
        }
        
        if storageManager.fetchPerson() != nil {
            progressIsBlock.isHidden = true
        }
    }
    
    func setupNavigationBar() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = .colorApp
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.tintColor = .white
    }
    
    func setupOverlayView() {
        view.addSubview(overlayView)
        view.bringSubviewToFront(overlayView)
        view.bringSubviewToFront(menuView)
    }
    
    func roundMenuCorners() {
        menuView.roundCorners(corners: [.topRight, .bottomRight], radius: 20)
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
    
    func showAlert() {
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
    
    @objc func doneButtonPressed() {
        searchBar.resignFirstResponder()
    }
}

// MARK: - Progress Bar
extension MainViewController: MainScreenDelegate {
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
        proteinProgressBar = createCircularProgress(xOffset: -171, color: .green, initialProgress: 0.0)
        fatsProgressBar = createCircularProgress(xOffset: -99, color: .orange, initialProgress: 0.0)
        carbohydratesProgressBar = createCircularProgress(xOffset: -27, color: .cyan, initialProgress: 0.0)
        caloriesProgressBar = createCircularProgress(xOffset: 45, color: .yellow, initialProgress: 0.0)
        waterProgressBar = createCircularProgress(xOffset: 117, color: .blue, initialProgress: 0.0)
        
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
        caloriesProgressBar?.progress = carbohydratesToday < carbohydratesProgramm
            ? Double(carbohydratesToday) / Double(carbohydratesProgramm)
            : 1.0
        caloriesProgressBar?.progress = caloriesToday < caloriesProgramm
            ? Double(caloriesToday) / Double(caloriesProgramm)
            : 1.0
        waterProgressBar?.progress = waterToday < waterProgramm
            ? Double(waterToday) / Double(waterProgramm)
            : 1.0
        
        proteinTodayLabel.text = proteinToday.formatted()
        fatsTodayLabel.text = fatsToday.formatted()
        carbohydratesTodayLabel.text = carbohydratesToday.formatted()
        caloriesTodayLabel.text = caloriesToday.formatted()
        waterTodayLabel.text = waterToday.formatted()
    
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
}

// MARK: - UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredProducts = searchText.isEmpty ? allProducts : allProducts.filter { $0.name.contains(searchText) }
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
