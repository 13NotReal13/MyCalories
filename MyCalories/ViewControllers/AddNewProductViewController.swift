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
    
    @IBOutlet var extendingNavigationBarView: UIView!
    @IBOutlet var productView: UIView!
    
    weak var delegate: MainScreenDelegate?
    
    private let storageManager = StorageManager.shared
    private var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFields()
        
        productView.setShadow(
            cornerRadius: 15,
            shadowColor: .black,
            shadowOffset: CGSize(width: 0, height: 2),
            shadowRadius: 6,
            shadowOpacity: 0.3
        )
    }
    
    override func viewDidLayoutSubviews() {
        extendingNavigationBarView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 50)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        doneButtonPressed()
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
}

// MARK: - Private Methods
private extension AddNewProductViewController {
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
