//
//  SettingsViewController.swift
//  MyCalories
//
//  Created by Иван Семикин on 05/04/2024.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    private let storageManager = StorageManager.shared
    private var userProgramm: UserProgramm!
    
    @IBOutlet var caloriesSwitch: UISwitch!
    @IBOutlet var caloriesTF: UITextField!
    @IBOutlet var caloriesOnLabel: UILabel!
    @IBOutlet var caloriesOffLabels: [UILabel]!
    
    @IBOutlet var bguSwitch: UISwitch!
    @IBOutlet var proteinsTF: UITextField!
    @IBOutlet var fatsTF: UITextField!
    @IBOutlet var carbohydratesTF: UITextField!
    
    @IBOutlet var bguOnLabel: UILabel!
    @IBOutlet var bguOffLabels: [UILabel]!
    
    @IBOutlet var waterSwitch: UISwitch!
    @IBOutlet var waterTF: UITextField!
    @IBOutlet var waterOnLabel: UILabel!
    @IBOutlet var waterOffLabels: [UILabel]!
    
    @IBOutlet var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSettings()
        setupCalories()
        setupBgu()
        setupWater()
        setTextFields()
        
        userProgramm = storageManager.fetchUserProgramm()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
        print("keyboard hide")
    }
    
    @IBAction func swithesActions(_ sender: UISwitch) {
        switch sender {
        case caloriesSwitch:
            setupCalories()
        case bguSwitch: 
            setupBgu()
        default:
            setupWater()
        }
    }
    
}

// MARK: - Private Methods
extension SettingsViewController {
    private func setTextFields() {
        caloriesTF.delegate = self
        proteinsTF.delegate = self
        fatsTF.delegate = self
        carbohydratesTF.delegate = self
        waterTF.delegate = self
        
        caloriesTF.setCornerRadius()
        proteinsTF.setCornerRadius()
        fatsTF.setCornerRadius()
        carbohydratesTF.setCornerRadius()
        waterTF.setCornerRadius()
    }
    
    private func fetchSettings() {
        let settings = storageManager.fetchSettings()
        caloriesSwitch.isOn = settings.caloriesEnabled
        bguSwitch.isOn = settings.bguEnabled
        waterSwitch.isOn = settings.waterEnabled
    }
    
    private func saveSettings() {
        storageManager.saveSettings(
            Settings(
                caloriesEnabled: caloriesSwitch.isOn,
                bguEnabled: bguSwitch.isOn,
                waterEnabled: waterSwitch.isOn
            )
        )
    }
    
    private func setupCalories() {
        if caloriesSwitch.isOn {
            caloriesTF.isEnabled = false
            caloriesTF.alpha = 0.3
            caloriesOnLabel.isEnabled = true
            caloriesOffLabels.forEach { label in
                label.isEnabled = false
            }
        } else {
            caloriesTF.isEnabled = true
            caloriesTF.alpha = 1
            caloriesOnLabel.isEnabled = false
            caloriesOffLabels.forEach { label in
                label.isEnabled = true
            }
        }
    }
    
    private func setupBgu() {
        if bguSwitch.isOn {
            proteinsTF.isEnabled = false
            fatsTF.isEnabled = false
            carbohydratesTF.isEnabled = false
            proteinsTF.alpha = 0.3
            fatsTF.alpha = 0.3
            carbohydratesTF.alpha = 0.3
            bguOnLabel.isEnabled = true
            bguOffLabels.forEach { label in
                label.isEnabled = false
            }
        } else {
            proteinsTF.isEnabled = true
            fatsTF.isEnabled = true
            carbohydratesTF.isEnabled = true
            proteinsTF.alpha = 1
            fatsTF.alpha = 1
            carbohydratesTF.alpha = 1
            bguOnLabel.isEnabled = false
            bguOffLabels.forEach { label in
                label.isEnabled = true
            }
        }
    }
    
    private func setupWater() {
        if waterSwitch.isOn {
            waterTF.isEnabled = false
            waterTF.alpha = 0.3
            waterOnLabel.isEnabled = true
            waterOffLabels.forEach { label in
                label.isEnabled = false
            }
        } else {
            waterTF.isEnabled = true
            waterTF.alpha = 1
            waterOnLabel.isEnabled = false
            waterOffLabels.forEach { label in
                label.isEnabled = true
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, text.count <= 4 else {
            showAlert(
                withTitle: "Упс..",
                andMessage: "Максимально допустимое значение: 9999",
                textField: textField
            )
            return
        }
        
        if textField == waterTF {
            scrollView.scrollToTop(animated: true)
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == waterTF {
            scrollView.scrollToBottom(animated: true)
        }
        
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        textField.inputAccessoryView = keyboardToolbar
        
        let saveButton = UIBarButtonItem(
            title: "Сохранить",
            style: .done,
            target: textField,
            action: #selector(resignFirstResponder)
        )
        
        let flexButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        keyboardToolbar.items = [flexButton, saveButton]
    }
}

// MARK: - Show Alert
extension SettingsViewController {
    func showAlert(withTitle title: String, andMessage message: String, textField: UITextField) {
        let alertFactory = AlertControllerFactory(title: title, message: message)
        let alert = alertFactory.createAlert { [unowned self] in
            switch textField {
            case self.caloriesTF:
                self.caloriesTF.text = String(userProgramm.calories)
            case self.proteinsTF:
                self.proteinsTF.text = String(userProgramm.proteins)
            case self.fatsTF:
                self.fatsTF.text = String(userProgramm.fats)
            case self.carbohydratesTF:
                self.carbohydratesTF.text = String(userProgramm.fats)
            default:
                self.waterTF.text = String(userProgramm.water)
                scrollView.scrollToTop(animated: true)
            }
        }
        present(alert, animated: true)
    }
}
