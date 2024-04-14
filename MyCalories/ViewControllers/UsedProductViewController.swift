//
//  UsedProductViewController.swift
//  MyCalories
//
//  Created by Иван Семикин on 14/04/2024.
//

import UIKit

final class UsedProductViewController: UIViewController {
    
    
    @IBOutlet var nameProductLabel: UILabel!
    @IBOutlet var proteinProductLabel: UILabel!
    @IBOutlet var fatsProductLabel: UILabel!
    @IBOutlet var carbohydratesProductLabel: UILabel!
    @IBOutlet var caloriesProductLabel: UILabel!
    
    @IBOutlet var weightTF: UITextField!
    @IBOutlet var dateTF: UITextField!
    @IBOutlet var addBarButtonItem: UIBarButtonItem!
    
    var selectedProduct: Product!
    
    private let storageManager = StorageManager.shared
    private let datePicker = UIDatePicker()
    private var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFields()
        setLabels()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkForAddProduct()
    }
    
    @IBAction func addBarButtonItemAction(_ sender: UIBarButtonItem) {
        storageManager.saveProductToHistory(
            Product(value: 
                        [
                            selectedProduct.name,
                            selectedProduct.protein,
                            selectedProduct.fats,
                            selectedProduct.carbohydrates,
                            selectedProduct.calories,
                            datePicker.date,
                            Double(weightTF.text ?? "0") ?? 0.0
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
private extension UsedProductViewController {
    func setTextFields() {
        weightTF.delegate = self
        weightTF.becomeFirstResponder()
        
        dateTF.delegate = self
        dateTF.inputAccessoryView = createToolbar()
        dateTF.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ru_RU")
    }
    
    func setLabels() {
        nameProductLabel.text = selectedProduct.name
        proteinProductLabel.text = "БЕЛКИ: \(selectedProduct.protein) Г."
        fatsProductLabel.text = "ЖИРЫ: \(selectedProduct.fats) Г."
        carbohydratesProductLabel.text = "УГЛЕВОДЫ: \(selectedProduct.carbohydrates) Г."
        caloriesProductLabel.text = "ККАЛ: \(selectedProduct.calories) НА 100 Г."
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
extension UsedProductViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        weightTF.inputAccessoryView = createToolbar()
    }
}
