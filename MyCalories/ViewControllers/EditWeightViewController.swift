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
    
    @IBOutlet var extendingNavigationBarView: UIView!
    @IBOutlet var editHeightView: UIView!
    
    var choosedProduct: Product?
    var choosedWater: Water?
    weak var delegate: HistoryViewControllerDelegate?
    
    private let storageManager = StorageManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        extendingNavigationBarView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 50)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        weightTF.resignFirstResponder()
    }
    
    @IBAction func cancelBarButtonItem(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func saveBarButtonItemAction(_ sender: UIBarButtonItem) {
        guard let value = weightTF.text, let doubleValue = Double(value), let intValue = Int(value) else { return }
        if let product = choosedProduct {
            storageManager.editProductFromHistory(product, withNewWeight: doubleValue) { [unowned self] in
                delegate?.updateTableView()
            }
        }
        
        if let water = choosedWater {
            storageManager.editWaterFromHistory(water, withNewML: intValue) { [unowned self] in
                delegate?.updateTableView()
            }
        }
        
        dismiss(animated: true)
    }
}

// MARK: - Private Methods
extension EditWeightViewController {
    private func setupUI() {
        weightTF.placeholder = choosedProduct != nil ? "г." : "мл."
        productNameLabel.text = choosedProduct != nil ? choosedProduct?.name : ""
        
        weightTF.text = choosedProduct != nil
            ? String(Int(choosedProduct?.weight ?? 0.0))
            : String(choosedWater?.ml ?? 0)
        
        weightTF.delegate = self
        weightTF.becomeFirstResponder()
        
        editHeightView.setShadow(
            cornerRadius: 15,
            shadowColor: .black,
            shadowOffset: CGSize(width: 0, height: 2),
            shadowRadius: 6,
            shadowOpacity: 0.3
        )
    }
    
    private func checkValue() {
        guard let text = weightTF.text, let textValue = Int(text) else { return }
        
        if textValue == 0 {
            showAlert()
            return
        } else if textValue > 5000 {
            showAlertError(textField: weightTF, type: .invalidValue)
            return
        }
        
        weightTF.text = String(textValue)
        saveBarButtonItem.isEnabled = true
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Необходимо ввести вес.",
            preferredStyle: .alert
        )
        
        let doneButton = UIAlertAction(title: "Ок", style: .default) { [unowned self] _ in
            weightTF.text = ""
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
    func textFieldDidBeginEditing(_ textField: UITextField) {
        weightTF.inputAccessoryView = createToolbar(title: "Готово", selector: #selector(doneButtonPressed))
        saveBarButtonItem.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkValue()
    }
}
