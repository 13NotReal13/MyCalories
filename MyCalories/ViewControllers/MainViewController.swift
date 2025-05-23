//
//  ViewController.swift
//  MyCalories
//
//  Created by Иван Семикин on 01/04/2024.
//

import UIKit
import RealmSwift
import GoogleMobileAds
import AppTrackingTransparency
import FirebaseAnalytics

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
    
    @IBOutlet var scanBarcodeButton: UIButton!
    @IBOutlet var waterButton: UIButton!
    @IBOutlet var noAdsButton: UIButton!
    @IBOutlet var addNewProductFromTableViewButton: UIButton!
    
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
    
    @IBOutlet var versionAppButton: UIButton!
    
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
    
    private var initViewDidLayoutSubviews = false
    
    private var interstitial: GADInterstitialAd?
    
    private let googleAdUnitID = "ca-app-pub-7511053995750557/9276091651"
    private let appIDAppStore = "6502844957"
    // testAdId: "ca-app-pub-3940256099942544/4411468910"
    // realAdId: "ca-app-pub-7511053995750557/9276091651"
    
    private lazy var overlayView: UIView = {
        let overlay = UIView(frame: view.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlay.alpha = 0
        return overlay
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setupForegroundNotification()
        storageManager.saveFirstOpenDate()
        setVersionForVersionButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !initViewDidLayoutSubviews {
            initializeProgressBars()
            setProgressBarValues()
            initViewDidLayoutSubviews = true
        }
        setupRoundedCornersForViews()
        searchBar.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        menuLeadingConstraint.constant = -menuView.frame.size.width
        menuTrailingConstraint.constant = view.frame.width
        overlayView.alpha = 0
        
        if PurchasesManager.shared.activeSubscription() == nil,
           storageManager.shouldShowAds(),
           storageManager.isFifteenMinutesPassedSinceLastAd() {
            showInterstitial()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if menuIsVisible {
            toogleMenu()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ATTrackingManager.requestTrackingAuthorization { [unowned self] _ in
            if PurchasesManager.shared.activeSubscription() == nil,
               storageManager.shouldShowAds(),
               storageManager.isFifteenMinutesPassedSinceLastAd() {
                showInterstitial()
            }
        }
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
            if let historyProductsVC = segue.destination as? HistoryViewController {
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
            addNewProductVC.segueFromBarcodeButton = false
            addNewProductVC.delegate = self
        case "SegueToAddNewProductVCFromBarcodeButton":
            guard let navigationVC = segue.destination as? UINavigationController else { return }
            guard let addNewProductVC = navigationVC.topViewController as? AddNewProductViewController else { return }
            addNewProductVC.segueFromBarcodeButton = true
            addNewProductVC.delegate = self
        default:
            return
        }
    }
    
    // MARK: - IBActions
    @IBAction func menuUIButtonAction() {
        toogleMenu()
    }
    
    @IBAction func menuBarButtonItemAction(_ sender: UIBarButtonItem) {
        toogleMenu()
    }
    
    @IBAction func waterButtonAction() {
        showAlertForAddWater()
    }
    
    @IBAction func rateButtonAction() {
        toogleMenu()
        showRatingAlert()
    }
    
    @IBAction func noAdsButtonAction() {
        toogleMenu()
        DispatchQueue.main.async { [unowned self] in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let navigationVC = storyboard.instantiateViewController(withIdentifier: "PurchasesNavigationController") as? UINavigationController else { return }
            
            
            navigationVC.modalPresentationStyle = .overFullScreen
            present(navigationVC, animated: true)
        }
    }
    
    @IBAction func versionAppButtonAction() {
        toogleMenu()
        
        let urlString = "https://apps.apple.com/app/id\(appIDAppStore)"
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - GoogleAd (GADFullScreenContentDelegate)
extension MainViewController: GADFullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        interstitial = nil
        loadInterstitial()
    }

    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        Analytics.logEvent("did_fail_present_fullscrenn_ad", parameters: nil)
    }
    
    func loadInterstitial() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: googleAdUnitID, request: request) { [unowned self] ad, error in
            if error != nil {
                Analytics.logEvent("load_interstitial_failed", parameters: nil)
                return
            }
            Analytics.logEvent("load_interstitial_success", parameters: nil)
            interstitial = ad
            interstitial?.fullScreenContentDelegate = self
        }
    }
    
    func showInterstitial() {
        if let interstitial = interstitial {
            storageManager.saveLastAdShownDate()
            Analytics.logEvent("show_interstitial_success", parameters: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                interstitial.present(fromRootViewController: self)
            }
        } else {
            Analytics.logEvent("show_interstitial_failed", parameters: nil)
            loadInterstitial()
        }
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
        searchBar.text = ""
        searchBar.searchTextField.resignFirstResponder()
        addNewProductFromTableViewButton.isHidden = true
        
        storageManager.fetchAllProducts { [unowned self] productsList in
            allProducts = productsList
            filteredProducts = allProducts
            tableView.reloadData()
        }
    }
}

// MARK: - Private Methods
private extension MainViewController {
    func initialSetup() {
        fetchData()
        setupUIs()
        setHiddenOfProgressBlock()
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
        
        // Tap on ProgressIsBlock
        let tapGestureProgressIsBlock = UITapGestureRecognizer(target: self, action: #selector(handleTapOnBlockProgressBar))
        progressIsBlock.isUserInteractionEnabled = true
        progressIsBlock.addGestureRecognizer(tapGestureProgressIsBlock)
        
        // Tap on ProgressView
        let tapGestureProgressView = UITapGestureRecognizer(target: self, action: #selector(handleTapOnProgressView))
        progressView.isUserInteractionEnabled = true
        progressView.addGestureRecognizer(tapGestureProgressView)
        
        // Shadows for Views
        shadowForTableViewView.setShadow(
            cornerRadius: 15,
            shadowColor: .black,
            shadowOffset: CGSize(width: 0, height: 2),
            shadowRadius: 6,
            shadowOpacity: 0.3
        )
        
        shadowForProgressBarView.setShadow(
            cornerRadius: 40,
            shadowColor: .black,
            shadowOffset: CGSize(width: 0, height: 2),
            shadowRadius: 6,
            shadowOpacity: 0.6
        )
        
        waterButton.layer.shadowColor = UIColor.black.cgColor
        waterButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        waterButton.layer.shadowRadius = 3
        waterButton.layer.shadowOpacity = 0.1
        waterButton.clipsToBounds = false
        waterButton.layer.masksToBounds = false
        
        scanBarcodeButton.layer.shadowColor = UIColor.black.cgColor
        scanBarcodeButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        scanBarcodeButton.layer.shadowRadius = 3
        scanBarcodeButton.layer.shadowOpacity = 0.1
        scanBarcodeButton.clipsToBounds = false
        scanBarcodeButton.layer.masksToBounds = false
        
        addNewProductFromTableViewButton.setTitle("Добавить новый продукт", for: .normal)
    }
    
    func setupRoundedCornersForViews() {
        menuView.roundCorners(corners: [.topRight, .bottomRight], radius: 20)
        extendingNavigationBarView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 50)
        progressIsBlock.roundCorners(corners: [.topLeft, .topRight], radius: 35)
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
                if PurchasesManager.shared.activeSubscription() == nil,
                   storageManager.shouldShowAds(),
                    storageManager.isFifteenMinutesPassedSinceLastAd() {
                    showInterstitial()
                }
            }
        }
        let cancelButton = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        alert.addTextField { textField in
            textField.placeholder = "мл."
            textField.keyboardType = .numberPad
            
            // Добавим наблюдатель для ограничения ввода
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: .main) { notification in
                if let textField = notification.object as? UITextField, let text = textField.text, let number = Int(text) {
                    if number > 9999 {
                        textField.text = String(text.dropLast())
                    }
                }
            }
        }
        
        present(alert, animated: true)
    }
    
    func deleteProduct(product: Product, indexPath: IndexPath) {
        storageManager.deleteProduct(product) { [unowned self] in
            fetchData()
        }
    }
    
    @objc func doneButtonPressed() {
        searchBar.resignFirstResponder()
    }
    
    @objc func handleTapOnBlockProgressBar() {
        if storageManager.fetchPerson() == nil {
            performSegue(withIdentifier: "SegueToProfileVC", sender: self)
        }
    }
    
    @objc func handleTapOnProgressView() {
        if progressIsBlock.isHidden {
            performSegue(withIdentifier: "SegueToHistoryProductsVC", sender: self)
        }
    }
    
    // Выход из фонового режима и обновление данных в прогресс баре
    private func setupForegroundNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func appWillEnterForeground() {
        if PurchasesManager.shared.activeSubscription() == nil,
           storageManager.shouldShowAds(),
           storageManager.isFifteenMinutesPassedSinceLastAd() {
            showInterstitial()
        }
        
        updateProgressBar()
        setVersionForVersionButton()
        
    }
    
    func setVersionForVersionButton() {
        guard let url = URL(string: "https://itunes.apple.com/lookup?id=\(appIDAppStore)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.fragmentsAllowed) as? [String: Any]
                if let results = json?["results"] as? [[String: Any]],
                   let appStoreVersion = results.first?["version"] as? String,
                   let localVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
                    if appStoreVersion.compare(localVersion, options: .numeric) == .orderedDescending {
                        DispatchQueue.main.async { [unowned self] in
                            versionAppButton.setTitle("Версия: \(localVersion) (обновить)", for: .normal)
                            versionAppButton.isEnabled = true
                        }
                    } else {
                        DispatchQueue.main.async { [unowned self] in
                            versionAppButton.setTitle("Версия: \(localVersion)", for: .normal)
                            versionAppButton.isEnabled = false
                        }
                    }
                }
            } catch {
                Analytics.logEvent("error_check_new_app_version", parameters: nil)
            }
        }
        .resume()
    }
    
    func showUpdateAlert(version: String) {
        let alert = UIAlertController(
            title: String.updateAlertTitle,
            message: String.updateAlertMessagePart1 + "\(version)" + String.updateAlertMessagePart2,
            preferredStyle: .alert
        )
        
        let updateAction = UIAlertAction(title: String.updateAlertOkButton, style: .default) { [unowned self] _ in
            let urlString = "https://apps.apple.com/app/id\(appIDAppStore)"
            if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        
        let cancelAction = UIAlertAction(title: String.cancel, style: .cancel, handler: nil)
        
        alert.addAction(updateAction)
        alert.addAction(cancelAction)
        
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
                rootViewController.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func setVisibleForAddNewProductButton() {
        if filteredProducts.isEmpty {
            addNewProductFromTableViewButton.isHidden = false
        } else {
            addNewProductFromTableViewButton.isHidden = true
        }
    }
}

// MARK: - Progress Bar
private extension MainViewController {
    func createCircularProgress(xOffset: CGFloat, color: UIColor, initialProgress: CGFloat) -> CircularProgressBar {
        let frameY = progressView.frame.height / 2 - 46
        let size = CGFloat(56)
        let progressBar = CircularProgressBar(
            frame: CGRect(
                x: xOffset - size / 2,
                y: frameY,
                width: size,
                height: size
            ),
            progressColor: color
        )
        progressBar.progress = initialProgress
        return progressBar
    }
    
    func initializeProgressBars() {
        let midWidth = progressView.frame.width / 2
        let width = progressView.frame.width - 32
        let intervalWidth = width / 10
        
        proteinProgressBar = createCircularProgress(
            xOffset: midWidth - intervalWidth * 4,
            color: .white,
            initialProgress: 0.0
        )
        proteinProgressBar?.setShadow(
            cornerRadius: 0,
            shadowColor: .white,
            shadowOffset: CGSize(width: 0, height: 0),
            shadowRadius: 2,
            shadowOpacity: 0.8
        )
        
        fatsProgressBar = createCircularProgress(
            xOffset: midWidth - intervalWidth * 2,
            color: .systemOrange,
            initialProgress: 0.0
        )
        fatsProgressBar?.setShadow(
            cornerRadius: 0,
            shadowColor: .systemOrange,
            shadowOffset: CGSize(width: 0, height: 0),
            shadowRadius: 3,
            shadowOpacity: 1
        )
        
        carbohydratesProgressBar = createCircularProgress(
            xOffset: midWidth,
            color: .cyan,
            initialProgress: 0.0
        )
        carbohydratesProgressBar?.setShadow(
            cornerRadius: 0,
            shadowColor: .cyan,
            shadowOffset: CGSize(width: 0, height: 0),
            shadowRadius: 2,
            shadowOpacity: 0.8
        )
        
        caloriesProgressBar = createCircularProgress(
            xOffset: midWidth + intervalWidth * 2,
            color: .yellow,
            initialProgress: 0.0
        )
        caloriesProgressBar?.setShadow(
            cornerRadius: 0,
            shadowColor: .yellow,
            shadowOffset: CGSize(width: 0, height: 0),
            shadowRadius: 2,
            shadowOpacity: 0.8
        )
        
        waterProgressBar = createCircularProgress(
            xOffset: midWidth + intervalWidth * 4,
            color: .blue,
            initialProgress: 0.0
        )
        waterProgressBar?.setShadow(
            cornerRadius: 0,
            shadowColor: .blue,
            shadowOffset: CGSize(width: 0, height: 0),
            shadowRadius: 2,
            shadowOpacity: 0.8
        )
        
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
        cell?.proteinProductLabel.text = String.proteinsTableView + "\(product.protein)"
        cell?.fatsProductLabel.text = String.fatsTableView + "\(product.fats)"
        cell?.carbohydratesProductLabel.text = String.carbohydratesTableView + "\(product.carbohydrates)"
        cell?.caloriesProductLabel.text = String.caloriesTableView + "\(product.calories)" + String.per100gTableView
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let product = filteredProducts[indexPath.row]
        
        let deleteButton = UIContextualAction(style: .normal, title: nil) { [unowned self] _, _, isDone in
            showAlertDelete(for: product.name) { [unowned self] in
                deleteProduct(product: product, indexPath: indexPath)
            }
            isDone(true)
        }
        
        deleteButton.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [deleteButton])
    }
}

// MARK: - UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredProducts = searchText.isEmpty ? allProducts : allProducts.filter("name CONTAINS[c] %@", searchText)
        tableView.reloadData()
        
        if !filteredProducts.isEmpty {
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        setVisibleForAddNewProductButton()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if !filteredProducts.isEmpty {
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        
        searchBar.inputAccessoryView = createToolbar(title: String.done, selector: #selector(doneButtonPressed))
    }
}
