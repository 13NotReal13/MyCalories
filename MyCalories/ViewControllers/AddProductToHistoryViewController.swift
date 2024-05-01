//
//  UsedProductViewController.swift
//  MyCalories
//
//  Created by Иван Семикин on 14/04/2024.
//

import UIKit

final class AddProductToHistoryViewController: UIViewController {
    
    @IBOutlet var nameProductLabel: UILabel!
    @IBOutlet var proteinProductLabel: UILabel!
    @IBOutlet var fatsProductLabel: UILabel!
    @IBOutlet var carbohydratesProductLabel: UILabel!
    @IBOutlet var caloriesProductLabel: UILabel!
    
    @IBOutlet var weightTF: UITextField!
    @IBOutlet var dateTF: UITextField!
    @IBOutlet var addBarButtonItem: UIBarButtonItem!
    
    weak var delegate: MainScreenDelegate?
    
    var selectedProduct: Product!
    
    private let storageManager = StorageManager.shared
    private let datePicker = UIDatePicker()
    private var activeTextField: UITextField?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFields()
        setLabels()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.updateProgressBar()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkForAddProduct()
    }
    
    @IBAction func addBarButtonItemAction(_ sender: UIBarButtonItem) {
        let weight = Double(weightTF.text ?? "0") ?? 0.0
        let weightRatio = weight / 100.0
        
        let adjustedProtein = (selectedProduct.protein * weightRatio * 100).rounded() / 100
        let adjustedFats = (selectedProduct.fats * weightRatio * 100).rounded() / 100
        let adjustedCarbohydrates = (selectedProduct.carbohydrates * weightRatio * 100).rounded() / 100
        let adjustedCalories = (selectedProduct.calories * weightRatio * 100).rounded() / 100
        
        storageManager.changeIndexAndColor(forProduct: selectedProduct) { [unowned self] in
            delegate?.updateTableView()
        }
        
        storageManager.saveProductToHistory(
            Product(
                value: [
                    selectedProduct.name,
                    adjustedProtein,
                    adjustedFats,
                    adjustedCarbohydrates,
                    adjustedCalories,
                    datePicker.date,
                    weight
                ]
            )
        )
        
        dismiss(animated: true)
    }
    
    deinit {
        print("UsedProductVC deinit")
    }
}

// MARK: - Private Methods
private extension AddProductToHistoryViewController {
    func setTextFields() {
        weightTF.delegate = self
        weightTF.becomeFirstResponder()
        
        weightTF.customStyle()
        dateTF.customStyle()
        
        dateTF.delegate = self
        dateTF.inputAccessoryView = createToolbar()
        dateTF.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ru_RU")
    }
    
    func setLabels() {
        nameProductLabel.text = selectedProduct.name
        proteinProductLabel.text = "\(selectedProduct.protein) г."
        fatsProductLabel.text = "\(selectedProduct.fats) г."
        carbohydratesProductLabel.text = "\(selectedProduct.carbohydrates) г."
        caloriesProductLabel.text = "\(selectedProduct.calories) кКал на 100 г."
    }
    
    func showAlert(fromTextField textField: UITextField) {
        let alert = UIAlertController(
            title: "Упс...",
            message: "Введите вес продукта",
            preferredStyle: .alert
        )
        let okButton = UIAlertAction(title: "ОК", style: .default) { _ in
            textField.text = ""
            textField.becomeFirstResponder()
            alert.dismiss(animated: true)
        }
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    func createToolbar() -> UIToolbar {
        let keyboardTolbar = UIToolbar()
        keyboardTolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(
            title: "Готово",
            style: .done,
            target: self,
            action: #selector(doneButtonPressed)
        )
        let flexButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        keyboardTolbar.setItems([flexButton, doneButton], animated: true)
        return keyboardTolbar
    }
    
    @objc private func doneButtonPressed() {
        guard let textField = activeTextField else { return }
        
        if textField == dateTF {
            dateTF.text = (Calendar.current.isDateInToday(datePicker.date)) ? "СЕГОДНЯ" : datePicker.dateToString(datePicker.date)
        }
        
        textField.resignFirstResponder()
        checkForAddProduct()
    }
    
    func checkForAddProduct() {
        guard let text = weightTF.text, let textInDouble = Double(text), textInDouble != 0 else {
            showAlert(fromTextField: weightTF)
            return
        }
        
        guard let date = dateTF.text, !date.isEmpty else { return }
        addBarButtonItem.isEnabled = true
    }
}

// MARK: - UITextFieldDelegate
extension AddProductToHistoryViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        weightTF.inputAccessoryView = createToolbar()
    }
}
