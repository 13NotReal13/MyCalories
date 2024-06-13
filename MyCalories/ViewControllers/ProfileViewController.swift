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
            String.lowTitle
        case .medium:
            String.mediumTitle
        case .high:
            String.highTitle
        }
    }
    
    var description: String {
        switch self {
        case .low:
            String.lowDescription
        case .medium:
            String.mediumDescription
        case .high:
            String.highDescription
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
            String.downWeight
        case .maintainWeight:
            String.maintainWeight
        case .upWeight:
            String.upWeight
        }
    }
}

final class ProfileViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var saveBarButtonItem: UIBarButtonItem!
    
    @IBOutlet var genderSegmentedControl: UISegmentedControl!
    @IBOutlet var dateOfBirthdayTF: UITextField!
    @IBOutlet var heightTF: UITextField!
    @IBOutlet var weightTF: UITextField!
    @IBOutlet var activityTF: UITextField!
    @IBOutlet var goalTF: UITextField!
    
    @IBOutlet var titleOfProgrammLabel: UILabel!
    @IBOutlet var proteinPerDayLabel: UILabel!
    @IBOutlet var fatsPerDayLabel: UILabel!
    @IBOutlet var carbohydratesPerDayLabel: UILabel!
    @IBOutlet var caloriesPerDayLabel: UILabel!
    @IBOutlet var waterPerDayLabel: UILabel!
    
    @IBOutlet var extendingNavigationBarView: UIView!
    @IBOutlet var profileView: UIView!
    @IBOutlet var recommendedProgrammView: UIView!
    
    @IBOutlet var formulaSourceButton: UIButton!
    
    // MARK: - Private Properties
    private let storageManager = StorageManager.shared
    private var person: Person?
    
    private let datePicker = UIDatePicker()
    private let pickerView = UIPickerView()
    
    private let activities: [Activity] = [.low, .medium, .high]
    private let goals: [Goal] = [.downWeight, .maintainWeight, .upWeight]
    private var activeTextField: UITextField?
    
    weak var delegate: MainScreenDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFields()
        getPerson()
        setRecommendedProgramm()
        setFormulaSourceButton()
        
        profileView.setShadow(
            cornerRadius: 15,
            shadowColor: .black,
            shadowOffset: CGSize(width: 0, height: 2),
            shadowRadius: 6,
            shadowOpacity: 0.3
        )
        
        pickerView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        extendingNavigationBarView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 50)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
        doneButtonPressed()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.setHiddenOfProgressBlock()
        delegate?.updateProgressBar()
    }
    
    @IBAction func savePersonBarButtonItem(_ sender: UIBarButtonItem) {
        guard let height = heightTF.text, let weight = weightTF.text,
              let activity = activityTF.text, let goal = goalTF.text,
              let heightInDouble = Double(height), let weightInDouble = Double(weight) else { return }
        
        storageManager.savePerson(
            Person(value:
                    [
                        genderSegmentedControl.selectedSegmentIndex == 0 ? String.male : String.female,
                        datePicker.date,
                        heightInDouble,
                        weightInDouble,
                        activity,
                        goal
                    ]
                  )
        )
        
        setRecommendedProgramm()
        saveBarButtonItem.isEnabled.toggle()
    }
    
    @IBAction func segmentedControlAction() {
        checkForSavePerson()
    }
    
    @IBAction func formulaSourceButtonAction() {
        if let url = URL(string: "https://en.m.wikipedia.org/wiki/Basal_metabolic_rate") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Private Methods
private extension ProfileViewController {
    func setTextFields() {
        dateOfBirthdayTF.delegate = self
        heightTF.delegate = self
        weightTF.delegate = self
        activityTF.delegate = self
        goalTF.delegate = self
        
        dateOfBirthdayTF.customStyle()
        heightTF.customStyle()
        weightTF.customStyle()
        activityTF.customStyle()
        goalTF.customStyle()
        
        dateOfBirthdayTF.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale.current
        
        activityTF.inputView = pickerView
        goalTF.inputView = pickerView
    }
    
    @objc private func doneButtonPressed() {
        guard let textField = activeTextField else { return }
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        
        switch textField {
        case dateOfBirthdayTF:
            dateOfBirthdayTF.text = datePicker.dateToString(datePicker.date)
        case heightTF, weightTF:
            checkTextOfTextField(textField)
        case activityTF:
            activityTF.text = activities[selectedRow].title
        default:
            goalTF.text = goals[selectedRow].title
        }
        
        textField.resignFirstResponder()
        checkForSavePerson()
    }
    
    func checkForSavePerson() {
        guard let dateOfBirthday = dateOfBirthdayTF.text,
              let height = heightTF.text,
              let weight = weightTF.text,
              let activity = activityTF.text,
              let goal = goalTF.text else { return }
        
        if !dateOfBirthday.isEmpty, !height.isEmpty, !weight.isEmpty,
           !activity.isEmpty, !goal.isEmpty {
            saveBarButtonItem.isEnabled = true
        } else {
            saveBarButtonItem.isEnabled = false
        }
    }
    
    func getPerson() {
        guard let person = storageManager.fetchPerson() else { return }
        
        genderSegmentedControl.selectedSegmentIndex = person.gender == String.male ? 0 : 1
        dateOfBirthdayTF.text = datePicker.dateToString(person.dateOfBirthday)
        heightTF.text = String(person.height)
        weightTF.text = String(person.weight)
        activityTF.text = person.activity
        goalTF.text = person.goal
    }
    
    func checkTextOfTextField(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.filter({ $0 == ","}).count > 1 || text.filter({ $0 == "."}).count > 1
            || text.hasPrefix(",") || text.hasSuffix(",")
                || text.hasPrefix(".") || text.hasSuffix(".") {
            showAlertError(textField: textField, type: .wrongFormat)
            saveBarButtonItem.isEnabled = false
            return
        } else if text.contains(",") {
            textField.text = text.replacingOccurrences(of: ",", with: ".")
        }
        
        guard let value = Double(text) else { return }
        if text.count > 7 || value > 600 {
            showAlertError(textField: textField, type: .invalidValue)
        }
    }

    func setRecommendedProgramm() {
        guard let person = storageManager.fetchPerson() else { return }
        let personAge = Date.getAge(fromDate: person.dateOfBirthday)
        
        var protein: Double
        var fats: Double
        var carbohydrates: Double
        var calories: Double
        var water: Double
        
        calories = person.gender == String.male
            ? (person.weight * 10.0) + (person.height * 6.25) - (personAge * 5) + 5
            : (person.weight * 10.0) + (person.height * 6.25) - (personAge * 5) - 161
        
        water = person.gender == String.male ? person.weight * 30 : person.weight * 25
        
        switch person.activity {
        case .lowTitle:
            calories *= 1.2
            water += person.gender == String.male ? (0.57 * 500) : (0.57 * 400)
        case .mediumTitle:
            calories *= 1.4
            water += person.gender == String.male ? (1.42 * 500) : (1.42 * 400)
        default:
            calories *= 1.8
            water += person.gender == String.male ? (2.0 * 500) : (2.0 * 400)
        }
        
        switch person.goal {
        case .downWeight:
            calories *= 0.8
            protein = calories * 0.5 / 4
            fats = calories * 0.2 / 9
            carbohydrates = calories * 0.3 / 4
            titleOfProgrammLabel.text = String.normForDownWeight
        case .maintainWeight:
            protein = calories * 0.3 / 4
            fats = calories * 0.3 / 9
            carbohydrates = calories * 0.4 / 4
            titleOfProgrammLabel.text = String.normForMaintainWeight
        default:
            calories *= 1.25
            protein = calories * 0.3 / 4
            fats = calories * 0.2 / 9
            carbohydrates = calories * 0.5 / 4
            titleOfProgrammLabel.text = String.normForUpWeight
        }
        
        proteinPerDayLabel.text = "\(Int(protein)) " + String.g
        fatsPerDayLabel.text = "\(Int(fats)) " + String.g
        carbohydratesPerDayLabel.text = "\(Int(carbohydrates)) " + String.g
        caloriesPerDayLabel.text = "\(Int(calories)) " + String.cal
        waterPerDayLabel.text = "\(Int(water)) " + String.ml
        
        let recommendedProgramm = RecommendedProgramm(
            value: [
                Int(protein),
                Int(fats),
                Int(carbohydrates),
                Int(calories),
                Int(water)
            ]
        )
        
        saveRecommendedProgramm(recommendedProgramm)
    }
    
    func saveRecommendedProgramm(_ programm: RecommendedProgramm) {
        storageManager.saveRecommendedProgramm(programm)
    }
    
    func setFormulaSourceButton() {
        let attributes: [NSAttributedString .Key: Any] = 
            [
                .font: UIFont.systemFont(ofSize: 13),
                .foregroundColor: UIColor.link,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        
        let attributedString = NSAttributedString(string: String.sourceOfFormula, attributes: attributes)
        
        formulaSourceButton.setAttributedTitle(attributedString, for: .normal)
    }
}

// MARK: - UITextFieldDelegate
extension ProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        textField.inputAccessoryView = createToolbar(title: String.done, selector: #selector(doneButtonPressed))
        saveBarButtonItem.isEnabled = false
        pickerView.reloadAllComponents()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        doneButtonPressed()
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
