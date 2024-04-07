//
//  SettingsViewController.swift
//  MyCalories
//
//  Created by Иван Семикин on 05/04/2024.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    private let storageManager = StorageManager.shared
    
    @IBOutlet var caloriesSwitch: UISwitch!
    @IBOutlet var caloriesTF: UITextField!
    @IBOutlet var caloriesOnLabel: UILabel!
    @IBOutlet var caloriesOffLabels: [UILabel]!
    
    @IBOutlet var bguSwitch: UISwitch!
    @IBOutlet var bguTFs: [UITextField]!
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
        
        caloriesTF.delegate = self
        bguTFs.forEach { textField in
            textField.delegate = self
        }
        waterTF.delegate = self
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

// MARK: - Setup On/Off settings
extension SettingsViewController {
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
            bguTFs.forEach { textField in
                textField.isEnabled = false
                textField.alpha = 0.3
            }
            bguOnLabel.isEnabled = true
            bguOffLabels.forEach { label in
                label.isEnabled = false
            }
        } else {
            bguTFs.forEach { textField in
                textField.isEnabled = true
                textField.alpha = 1
            }
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

extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, text.count <= 5 else {
            return
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == waterTF {
            scrollView.scrollToBottom(animated: true)
            print("ghdjk")
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

extension UIScrollView {
    func scrollToBottom(animated: Bool) {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        setContentOffset(bottomOffset, animated: animated)
    }
}
