//
//  UIViewController + Ext.swift
//  MyCalories
//
//  Created by Иван Семикин on 16/05/2024.
//

import UIKit

enum TypeOfAlert {
    case invalidValue
    case wrongFormat
}

extension UIViewController {
    func createToolbar(title: String, isCancelSelector: Bool? = nil, selector: Selector) -> UIToolbar {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        
        let flexButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        let doneButton = UIBarButtonItem(
            title: title,
            style: .done,
            target: self,
            action: selector
        )
        
        if isCancelSelector != nil {
            let cancelButton = UIBarButtonItem(
                title: "Отмена",
                style: .plain,
                target: self,
                action: #selector(cancelButtonSelector)
            )
            keyboardToolbar.setItems([cancelButton, flexButton, doneButton], animated: true)
        } else {
            keyboardToolbar.setItems([flexButton, doneButton], animated: true)
        }
        
        return keyboardToolbar
    }
    
    @objc func cancelButtonSelector() {
        view.endEditing(true)
    }
    
    func showAlertError(textField: UITextField, type: TypeOfAlert) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: type == .invalidValue ? "Недопустимое значение" : "Неверный формат",
            preferredStyle: .alert
        )
        
        let okButton = UIAlertAction(title: "OK", style: .default) { _ in
            textField.text = ""
            textField.becomeFirstResponder()
            alert.dismiss(animated: true)
        }
        
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    func showAlertDelete(for target: String, inTableView tableView: UITableView? = nil, completion: @escaping() -> Void) {
        let alert = UIAlertController(title: "Вы уверены, что хотите удалить?", message: target, preferredStyle: .alert)
        
        let deleteButton = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            completion()
        }
        
        let cancelButton = UIAlertAction(title: "Отмена", style: .cancel) { _ in
            alert.dismiss(animated: true)
            guard let tableView, let indexPath = tableView.indexPathForSelectedRow else { return }
                tableView.deselectRow(at: indexPath, animated: true)
        }
        
        alert.addAction(deleteButton)
        alert.addAction(cancelButton)
        present(alert, animated: true)
    }
}
