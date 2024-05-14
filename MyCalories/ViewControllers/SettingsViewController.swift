//
//  SettingsViewController.swift
//  MyCalories
//
//  Created by Иван Семикин on 05/04/2024.
//

import UIKit
import RealmSwift

final class SettingsViewController: UIViewController {
    
    // MARK: - IBOutlets
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
    
    @IBOutlet var extendingNavigationBarView: UIView!
    @IBOutlet var caloriesView: UIView!
    @IBOutlet var bguView: UIView!
    @IBOutlet var waterView: UIView!
    
    private let storageManager = StorageManager.shared
    private var userProgramm: UserProgramm?
    
    weak var delegate: MainScreenDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userProgramm = storageManager.fetchUserProgramm()
        
        fetchSettings()
        setCalories()
        setBgu()
        setWater()
        initTextFieldsDelegate()
        setUserProgramm()
    }
    
    @IBAction func swithesActions(_ sender: UISwitch) {
        switch sender {
        case caloriesSwitch:
            setCalories()
        case bguSwitch: 
            setBgu()
        default:
            setWater()
        }
        
        saveSettings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.updateProgressBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        extendingNavigationBarView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 50)
        setShadows()
    }
}

// MARK: - Private Methods
extension SettingsViewController {
    private func initTextFieldsDelegate() {
        caloriesTF.delegate = self
        proteinsTF.delegate = self
        fatsTF.delegate = self
        carbohydratesTF.delegate = self
        waterTF.delegate = self
        
        caloriesTF.customStyle()
        proteinsTF.customStyle()
        fatsTF.customStyle()
        carbohydratesTF.customStyle()
        waterTF.customStyle()
    }
    
    private func fetchSettings() {
        let settings = storageManager.fetchSettings()
        caloriesSwitch.isOn = settings.caloriesEnabled
        bguSwitch.isOn = settings.bguEnabled
        waterSwitch.isOn = settings.waterEnabled
    }
    
    private func saveSettings() {
        let settings = Settings(
            caloriesEnabled: caloriesSwitch.isOn,
            bguEnabled: bguSwitch.isOn,
            waterEnabled: waterSwitch.isOn
        )
        
        storageManager.saveSettings(settings)
    }
    
    private func setUserProgramm() {
        guard let userProgramm = userProgramm else { return }
        caloriesTF.text = String(userProgramm.calories)
        proteinsTF.text = String(userProgramm.proteins)
        fatsTF.text = String(userProgramm.fats)
        carbohydratesTF.text = String(userProgramm.carbohydrates)
        waterTF.text = String(userProgramm.water)
    }
    
    private func setCalories() {
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
    
    private func setBgu() {
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
    
    private func setWater() {
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
    
    private func getNutrition(fromTextField textField: UITextField) -> Nutrition {
        switch textField {
        case caloriesTF:
            return .calories
        case proteinsTF:
            return .proteins
        case fatsTF:
            return .fats
        case carbohydratesTF:
            return .carbohydrates
        default:
            return .water
        }
    }
    
    private func setShadows() {
        caloriesView.setShadow(
            cornerRadius: 15,
            shadowColor: .black,
            shadowOffset: CGSize(width: 0, height: 2),
            shadowRadius: 6,
            shadowOpacity: 0.3
        )
        
        bguView.setShadow(
            cornerRadius: 15,
            shadowColor: .black,
            shadowOffset: CGSize(width: 0, height: 2),
            shadowRadius: 6,
            shadowOpacity: 0.3
        )
        
        waterView.setShadow(
            cornerRadius: 15,
            shadowColor: .black,
            shadowOffset: CGSize(width: 0, height: 2),
            shadowRadius: 6,
            shadowOpacity: 0.3
        )
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
        
        if let newValue = Int(text) {
            textField.text = String(newValue)
            let nutrition = getNutrition(fromTextField: textField)
            storageManager.saveUserProgramm(nutrition: nutrition, newValue: newValue)
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
                self.caloriesTF.text = String(userProgramm?.calories ?? 0)
            case self.proteinsTF:
                self.proteinsTF.text = String(userProgramm?.proteins ?? 0)
            case self.fatsTF:
                self.fatsTF.text = String(userProgramm?.fats ?? 0)
            case self.carbohydratesTF:
                self.carbohydratesTF.text = String(userProgramm?.fats ?? 0)
            default:
                self.waterTF.text = String(userProgramm?.water ?? 0)
                scrollView.scrollToTop(animated: true)
            }
        }
        present(alert, animated: true)
    }
}
