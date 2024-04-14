//
//  UsedProductViewController.swift
//  MyCalories
//
//  Created by Иван Семикин on 14/04/2024.
//

import UIKit

final class UsedProductViewController: UIViewController {
    
    @IBOutlet var weightTF: UITextField!
    @IBOutlet var dateTF: UITextField!
    @IBOutlet var addBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weightTF.delegate = self
        dateTF.delegate = self
        weightTF.becomeFirstResponder()
    }
    
    @objc func doneButtonPressed() {
        guard let text = weightTF.text, let textInDouble = Double(text), textInDouble != 0 else {
            showAlert(fromTextField: weightTF)
            return
        }
        weightTF.resignFirstResponder()
        addBarButtonItem.isEnabled = true
    }
    
    private func showAlert(fromTextField textField: UITextField) {
        let alert = UIAlertController(title: "Упс...", message: "Введите вес продукта", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "ОК", style: .default) { _ in
            textField.text = ""
            alert.dismiss(animated: true)
        }
        alert.addAction(okButton)
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension UsedProductViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
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
        weightTF.inputAccessoryView = keyboardTolbar
    }
}
