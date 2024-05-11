//
//  EditPositionFromHistory.swift
//  MyCalories
//
//  Created by Иван Семикин on 30/04/2024.
//

import UIKit

final class EditWeightViewController: UIViewController {
    
    @IBOutlet var saveBarButtonItem: UIBarButtonItem!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var weightTF: UITextField!
    
    var choosedProduct: Product?
    var choosedWater: Water?
    weak var delegate: HistroryProductsViewControllerDelegate?
    
    private let storageManger = StorageManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weightTF.placeholder = choosedProduct != nil ? "г." : "мл."
        productNameLabel.text = choosedProduct != nil ? choosedProduct?.name : ""
        
        weightTF.text = choosedProduct != nil 
            ? String(Int(choosedProduct?.weight ?? 0.0))
            : String(choosedWater?.ml ?? 0)
        
        weightTF.delegate = self
        weightTF.inputAccessoryView = createToolbar()
        weightTF.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        weightTF.resignFirstResponder()
    }
    
    @IBAction func saveBarButtonItemAction(_ sender: UIBarButtonItem) {
        guard let value = weightTF.text, let doubleValue = Double(value), let intValue = Int(value) else { return }
        if let product = choosedProduct {
            storageManger.editProductFromHistory(product, withNewWeight: doubleValue) { [unowned self] in
                delegate?.updateTableView()
            }
        }
        
        if let water = choosedWater {
            storageManger.editWaterFromHistory(water, withNewML: intValue) { [unowned self] in
                delegate?.updateTableView()
            }
        }
        
        dismiss(animated: true)
    }
}

// MARK: - Private Methods
extension EditWeightViewController {
    private func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
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
        
        toolbar.items = [flexButton, doneButton]
        return toolbar
    }
    
    private func checkValue() {
        guard let text = weightTF.text, let textValue = Int(text), textValue != 0 else {
            showAlert()
            saveBarButtonItem.isEnabled = false
            return
        }
        saveBarButtonItem.isEnabled = true
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Необходимо ввести вес.",
            preferredStyle: .alert
        )
        
        let doneButton = UIAlertAction(title: "Ок", style: .default) { [unowned self] _ in
            weightTF.becomeFirstResponder()
        }
        
        alert.addAction(doneButton)
        present(alert, animated: true)
    }
    
    @objc private func doneButtonPressed() {
        weightTF.resignFirstResponder()
    }
}

// MARK: - UITextFieldDelegate
extension EditWeightViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkValue()
    }
}
