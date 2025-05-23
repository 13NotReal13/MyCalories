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
    
    weak var delegate: MainScreenDelegate?
    
    private let storageManager = StorageManager.shared
    private var userProgramm: UserProgramm?
    private var activeTextField: UITextField?
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.updateProgressBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        extendingNavigationBarView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 50)
        setShadows()
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
}

// MARK: - Private Methods
private extension SettingsViewController {
    func initTextFieldsDelegate() {
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
    
    @objc func saveButtonPressed() {
        guard let textField = activeTextField, let text = textField.text else { return }
        
        if text.count > 4 {
            let firstValue = textField.text
            showAlertError(textField: textField, type: .invalidValue)
            textField.text = firstValue
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
        
        if text.isEmpty {
            setUserProgramm()
        }
        
        textField.resignFirstResponder()
    }
    
    func fetchSettings() {
        let settings = storageManager.fetchSettings()
        caloriesSwitch.isOn = settings.caloriesEnabled
        bguSwitch.isOn = settings.bguEnabled
        waterSwitch.isOn = settings.waterEnabled
    }
    
    func saveSettings() {
        let settings = Settings(
            caloriesEnabled: caloriesSwitch.isOn,
            bguEnabled: bguSwitch.isOn,
            waterEnabled: waterSwitch.isOn
        )
        
        storageManager.saveSettings(settings)
    }
    
    func setUserProgramm() {
        guard let userProgramm = userProgramm else { return }
        caloriesTF.text = String(userProgramm.calories)
        proteinsTF.text = String(userProgramm.proteins)
        fatsTF.text = String(userProgramm.fats)
        carbohydratesTF.text = String(userProgramm.carbohydrates)
        waterTF.text = String(userProgramm.water)
    }
    
    func setCalories() {
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
    
    func setBgu() {
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
    
    func setWater() {
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
    
    func getNutrition(fromTextField textField: UITextField) -> Nutrition {
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
    
    func setShadows() {
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
        saveButtonPressed()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        textField.inputAccessoryView = createToolbar(title: "Сохранить", selector: #selector(saveButtonPressed))
        
        if textField == waterTF {
            scrollView.scrollToBottom(animated: true)
        }
    }
}
