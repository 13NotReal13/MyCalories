//
//  SettingsViewController.swift
//  MyCalories
//
//  Created by Иван Семикин on 05/04/2024.
//

import UIKit

final class SettingsViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func caloriesSwitchAction() {
        setupCalories()
    }
    
    @IBAction func bguSwitchAction() {
        setupBgu()
    }
    
    @IBAction func waterSwitchAction() {
        setupWater()
    }
}

// MARK: - Setup On/Off settings
extension SettingsViewController {
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
