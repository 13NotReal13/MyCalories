//
//  AddNewProductViewController.swift
//  MyCalories
//
//  Created by Иван Семикин on 14/04/2024.
//

import UIKit

final class AddNewProductViewController: UIViewController {
    
    @IBOutlet var addBarButtonItem: UIBarButtonItem!
    
    @IBOutlet var nameTF: UITextField!
    @IBOutlet var proteinTF: UITextField!
    @IBOutlet var fatsTF: UITextField!
    @IBOutlet var carbohydratesTF: UITextField!
    @IBOutlet var caloriesTF: UITextField!
    
    weak var delegate: MainScreenDelegate?
    
    private let storageManager = StorageManager.shared
    private var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFields()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
        checkForAddProduct()
    }
    
    @IBAction func addBarButtonItemAction(_ sender: UIBarButtonItem) {
        storageManager.saveNewProductToUsedProducts(
            Product(value:
                        [
                            nameTF.text ?? "",
                            Double(proteinTF.text ?? "0") ?? 0.0,
                            Double(fatsTF.text ?? "0") ?? 0.0,
                            Double(carbohydratesTF.text ?? "0") ?? 0.0,
                            Double(caloriesTF.text ?? "0") ?? 0.0,
                        ]
                   )
        )
        
        dismiss(animated: true)
    }
}

// MARK: - Private Methods
private extension AddNewProductViewController {
    func setTextFields() {
        nameTF.delegate = self
        proteinTF.delegate = self
        fatsTF.delegate = self
        carbohydratesTF.delegate = self
        caloriesTF.delegate = self
        
        nameTF.inputAccessoryView = createToolbar()
        proteinTF.inputAccessoryView = createToolbar()
        fatsTF.inputAccessoryView = createToolbar()
        carbohydratesTF.inputAccessoryView = createToolbar()
        caloriesTF.inputAccessoryView = createToolbar()
        
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
    
    func createToolbar() -> UIToolbar {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
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
        keyboardToolbar.setItems([flexButton, doneButton], animated: true)
        return keyboardToolbar
    }
    
    func checkTextOfTextField(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.filter({ $0 == ","}).count > 1 || text.filter({ $0 == "."}).count > 1 {
            showAlert(fromTextField: textField)
        } else if text.hasPrefix(",") || text.hasSuffix(",") {
            showAlert(fromTextField: textField)
        } else if text.hasPrefix(".") || text.hasSuffix(".") {
            showAlert(fromTextField: textField)
        } else if text.contains(",") {
            textField.text = text.replacingOccurrences(of: ",", with: ".")
        }
    }
    
    func showAlert(fromTextField textField: UITextField) {
        let alert = UIAlertController(title: "Упс..", message: "Неверный формат", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { _ in
            textField.text = ""
            textField.becomeFirstResponder()
            alert.dismiss(animated: true)
        }
        alert.addAction(okButton)
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension AddNewProductViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        doneButtonPressed()
    }
}
