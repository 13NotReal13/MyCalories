//
//  ProfileViewController.swift
//  MyCalories
//
//  Created by Иван Семикин on 01/04/2024.
//

import UIKit

enum Activity {
    case low
    case medium
    case high
    
    var title: String {
        switch self {
        case .low:
            "Низкая"
        case .medium:
            "Средняя"
        case .high:
            "Высокая"
        }
    }
    
    var description: String {
        switch self {
        case .low:
            "Низкая (1-2 тренировки в неделю или сидячий образ жизни)"
        case .medium:
            "Средняя (3-5 тренировок в неделю или лёгкие физические нагрузки)"
        case .high:
            "Высокая (6-7 тренировок в неделю или тяжёлые физические нагрузки)"
        }
    }
}
enum Goal {
    case downWeight
    case maintainWeight
    case upWeight
    
    var title: String {
        switch self {
        case .downWeight:
            "Снизить вес"
        case .maintainWeight:
            "Удержать вес"
        case .upWeight:
            "Набрать вес"
        }
    }
}

final class ProfileViewController: UIViewController {
    
    @IBOutlet var genderSegmentedControl: UISegmentedControl!
    @IBOutlet var dateOfBirthdayTF: UITextField!
    @IBOutlet var heightTF: UITextField!
    @IBOutlet var weightTF: UITextField!
    @IBOutlet var activityTF: UITextField!
    @IBOutlet var goalTF: UITextField!
    
    @IBOutlet var saveButton: UIBarButtonItem!
    
    private let storageManager = StorageManager.shared
    private var person: Person?
    
    private let datePicker = UIDatePicker()
    private let pickerView = UIPickerView()
    
    private let activities: [Activity] = [.low, .medium, .high]
    private let goals: [Goal] = [.downWeight, .maintainWeight, .upWeight]
    private var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFields()
    }
    
    @IBAction func saveBarButtonItemAtion(_ sender: UIBarButtonItem) {
        saveButton.isEnabled.toggle()
        print(datePicker.date)
    }
    
}

// MARK: - Private Methods
private extension ProfileViewController {
    func setTextFields() {
        getPerson()
        pickerView.delegate = self
        
        dateOfBirthdayTF.delegate = self
        heightTF.delegate = self
        weightTF.delegate = self
        activityTF.delegate = self
        goalTF.delegate = self
        
        dateOfBirthdayTF.inputAccessoryView = createToolbar()
        dateOfBirthdayTF.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ru_RU")
        
        heightTF.inputAccessoryView = createToolbar()
        weightTF.inputAccessoryView = createToolbar()
        
        activityTF.inputView = pickerView
        activityTF.inputAccessoryView = createToolbar()
        
        goalTF.inputView = pickerView
        goalTF.inputAccessoryView = createToolbar()
    }
    
    @objc func doneButtonPressed() {
        guard let textField = activeTextField else { return }
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        
        switch textField {
        case dateOfBirthdayTF:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            
            let selectedDate = datePicker.date
            dateOfBirthdayTF.text = dateFormatter.string(from: selectedDate)
            
            dateOfBirthdayTF.resignFirstResponder()
        case heightTF:
            heightTF.resignFirstResponder()
        case weightTF:
            weightTF.resignFirstResponder()
        case activityTF:
            activityTF.text = activities[selectedRow].title
            activityTF.resignFirstResponder()
        default:
            goalTF.text = goals[selectedRow].title
            goalTF.resignFirstResponder()
        }
        
        guard let dateOfBirthday = dateOfBirthdayTF.text,
              let height = heightTF.text,
              let weight = weightTF.text,
              let activity = activityTF.text,
              let goal = goalTF.text else { return }
        
        if !dateOfBirthday.isEmpty, !height.isEmpty, !weight.isEmpty,
           !activity.isEmpty, !goal.isEmpty {
            saveButton.isEnabled = true
        }
    }
    
    func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(doneButtonPressed))
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexButton, doneButton], animated: true)
        
        return toolbar
    }
    
    func getPerson() {
        guard let person = storageManager.fetchPerson() else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        dateOfBirthdayTF.text = dateFormatter.string(from: person.dateOfBirthday)
        heightTF.text = String(person.height)
        weightTF.text = String(person.weight)
        activityTF.text = person.activity
        goalTF.text = person.goal
    }
}

// MARK: - UITextFieldDelegate
extension ProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        pickerView.reloadAllComponents()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == dateOfBirthdayTF {
            
        } else {
            
        }
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension ProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let textField = activeTextField else { return 0 }
        let number = (textField == activityTF) ? activities.count : goals.count
        return number
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        guard let textField = activeTextField else { return UIView() }
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.text = (textField == activityTF) ? activities[row].description : goals[row].title
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        guard let textField = activeTextField else { return 0 }
        return (textField == activityTF) ? 60 : 30
    }
}
