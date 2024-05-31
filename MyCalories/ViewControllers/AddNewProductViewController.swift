//
//  AddNewProductViewController.swift
//  MyCalories
//
//  Created by Иван Семикин on 14/04/2024.
//

import UIKit
import BarcodeScanner
import AVFoundation
import FirebaseAnalytics

final class AddNewProductViewController: UIViewController {
    
    @IBOutlet var addBarButtonItem: UIBarButtonItem!
    @IBOutlet var openFoodFactsButton: UIButton!
    @IBOutlet var sourceOpenFoodStackView: UIStackView!
    
    @IBOutlet var nameTF: UITextField!
    @IBOutlet var proteinTF: UITextField!
    @IBOutlet var fatsTF: UITextField!
    @IBOutlet var carbohydratesTF: UITextField!
    @IBOutlet var caloriesTF: UITextField!
    
    @IBOutlet var extendingNavigationBarView: UIView!
    @IBOutlet var productView: UIView!
    
    weak var delegate: MainScreenDelegate?
    
    private let storageManager = StorageManager.shared
    private var activeTextField: UITextField?
    
    private var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        extendingNavigationBarView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 50)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        doneButtonPressed()
    }
    
    @IBAction func barcodeScannerButtonAction() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // Разрешение уже предоставлено
            startScanning()
        case .notDetermined: // Разрешение еще не запрашивалось
            AVCaptureDevice.requestAccess(for: .video) { [unowned self] granted in
                if granted {
                    startScanning()
                }
            }
        default: // Разрешение отклонено или ограничено
            promptForCameraAccess()
            break
        }
    }
    
    @IBAction func addBarButtonItemAction(_ sender: UIBarButtonItem) {
        let product = Product(value:
                                [
                                    nameTF.text ?? "",
                                    Double(proteinTF.text ?? "0") ?? 0.0,
                                    Double(fatsTF.text ?? "0") ?? 0.0,
                                    Double(carbohydratesTF.text ?? "0") ?? 0.0,
                                    Double(caloriesTF.text ?? "0") ?? 0.0,
                                ]
                           )
        
        storageManager.addNewProductToBase(product) { [unowned self] in
            delegate?.updateTableView()
        }
        
        dismiss(animated: true)
    }
    
    
    @IBAction func cancelBarButtonItem(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func openFoodFactsButtonAction() {
        if let url = URL(string: "https://world.openfoodfacts.org") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Private Methods
private extension AddNewProductViewController {
    func setupUI() {
        setTextFields()
        setActivityIndicator()
        setOpenFoodFactsButton()
        sourceOpenFoodStackView.isHidden = true
        
        productView.setShadow(
            cornerRadius: 15,
            shadowColor: .black,
            shadowOffset: CGSize(width: 0, height: 2),
            shadowRadius: 6,
            shadowOpacity: 0.3
        )
    }
    
    func setTextFields() {
        nameTF.delegate = self
        proteinTF.delegate = self
        fatsTF.delegate = self
        carbohydratesTF.delegate = self
        caloriesTF.delegate = self
        
        nameTF.customStyle()
        proteinTF.customStyle()
        fatsTF.customStyle()
        carbohydratesTF.customStyle()
        caloriesTF.customStyle()
        
        nameTF.becomeFirstResponder()
    }
    
    @objc func doneButtonPressed() {
        guard let textField = activeTextField else { return }
        if textField != nameTF {
            checkTextOfTextField(textField)
        }
        textField.resignFirstResponder()
        checkForAddProduct()
    }
    
    func checkForAddProduct() {
        guard let name = nameTF.text,
              let protein = proteinTF.text,
              let fats = fatsTF.text,
              let carbohydrates = carbohydratesTF.text,
              let calories = caloriesTF.text else { return }
        if !name.isEmpty, !protein.isEmpty, !fats.isEmpty, !carbohydrates.isEmpty, !calories.isEmpty {
            addBarButtonItem.isEnabled = true
        } else {
            addBarButtonItem.isEnabled = false
        }
    }
    
    func checkTextOfTextField(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.filter({ $0 == ","}).count > 1 || text.filter({ $0 == "."}).count > 1
        || text.hasPrefix(",") || text.hasSuffix(",")
        || text.hasPrefix(".") || text.hasSuffix(".") {
            showAlertError(textField: textField, type: .wrongFormat)
            return
        } else if text.contains(",") {
            textField.text = text.replacingOccurrences(of: ",", with: ".")
        }
        
        guard let value = Double(text) else { return }
        if text.count > 7 || value > 1500.0 {
            showAlertError(textField: textField, type: .invalidValue)
            return
        }
        
        textField.text = String(value)
    }
    
    func setActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    func clearTextFields() {
        nameTF.text = ""
        proteinTF.text = ""
        fatsTF.text = ""
        carbohydratesTF.text = ""
        caloriesTF.text = ""
    }
    
    func setOpenFoodFactsButton() {
        let attributes: [NSAttributedString .Key: Any] =
            [
                .font: UIFont.systemFont(ofSize: 13),
                .foregroundColor: UIColor.link,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        
        let attributedString = NSAttributedString(string: "Open Food Facts", attributes: attributes)
        
        openFoodFactsButton.setAttributedTitle(attributedString, for: .normal)
    }
}

// MARK: - UITextFieldDelegate
extension AddNewProductViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        textField.inputAccessoryView = createToolbar(title: "Готово", selector: #selector(doneButtonPressed))
        addBarButtonItem.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        doneButtonPressed()
    }
}

// MARK: - BarcodeScanner
extension AddNewProductViewController: BarcodeScannerCodeDelegate,
                                        BarcodeScannerErrorDelegate,
                                        BarcodeScannerDismissalDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        activityIndicator.startAnimating()
        searchProduct(withBarcode: code)
        controller.dismiss(animated: true)
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error)
    }
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true)
    }
    
    private func startScanning() {
        DispatchQueue.main.async { [unowned self] in
            let viewController = BarcodeScannerViewController()
            viewController.codeDelegate = self
            viewController.errorDelegate = self
            viewController.dismissalDelegate = self
            
            clearTextFields()
            present(viewController, animated: true)
        }
    }
    
    private func searchProduct(withBarcode barcode: String) {
        let url = URL(string: "https://world.openfoodfacts.org/api/v3/product/\(barcode).json")!
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
        let bundleIdentifier = Bundle.main.bundleIdentifier ?? "unknown"
        
        // Создание строки User-Agent
        let userAgent = "\(bundleIdentifier)/\(appVersion) (\(bundleIdentifier))"
        
        var request = URLRequest(url: url)
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                Analytics.logEvent("scan_product_error", parameters: nil)
                print("Error: \(error?.localizedDescription ?? "No data")")
                return
            }
            
            DispatchQueue.main.async { [unowned self] in
                processProductData(data)
            }
        }
        .resume()
    }
    
    private func processProductData(_ data: Data) {
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(SearchProduct.self, from: data)
            
            activityIndicator.stopAnimating()
            
            if let product = response.product {
                updateUIWithProductDetails(product)
                Analytics.logEvent("scan_product_done", parameters: nil)
            } else if response.errors != nil || response.result?.id == "product_not_found" {
                showAlertWithMessage(title:"Продукт не найден", message: "Возможные варианты решения: \n1. Убедитесь, что сканируете только штрихкод, без лишних цифровых символов вокруг; \n2. Проверьте, не осталось ли на продукте других штрих-кодов или QR-кодов.")
                Analytics.logEvent("scan_product_not_found", parameters: nil)
            }
        } catch {
            showAlertWithMessage(title: "Продукт не найден", message: "Возможные варианты решения: \n1. Убедитесь, что сканируете только штрихкод, без лишних цифровых символов вокруг; \n2. Проверьте, не осталось ли на продукте других штрих-кодов или QR-кодов.")
            Analytics.logEvent("scan_product_not_found", parameters: nil)
        }
    }

    private func updateUIWithProductDetails(_ product: FoundProduct) {
        guard let protein = product.nutriments.proteins,
              let fats = product.nutriments.fat,
              let carbohydrates = product.nutriments.carbohydrates,
              let calories = product.nutriments.energyKcal else {
            
            nameTF.text = product.productName
            showAlertWithMessage(title: "Информация", message: "Некоторые данные отсутствуют.")
            
            return
        }
        
        nameTF.text = product.productName
        proteinTF.text = String(protein)
        fatsTF.text = String(fats)
        carbohydratesTF.text = String(carbohydrates)
        caloriesTF.text = String(calories)
        
        sourceOpenFoodStackView.isHidden = false
    }
    
    private func showAlertWithMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        self.present(alert, animated: true)
    }
    
    private func promptForCameraAccess() {
        let alert = UIAlertController(title: "Доступ к камере ограничен",
                                      message: "Для сканирования штрихкодов необходимо разрешить доступ к камере в настройках. Пожалуйста, перейдите в Настройки и включите доступ к камере для этого приложения.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Открыть Настройки", style: .default) { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        })
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
