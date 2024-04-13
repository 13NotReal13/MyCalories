//
//  ProfileViewController.swift
//  MyCalories
//
//  Created by Иван Семикин on 01/04/2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    @IBOutlet var gender: UISegmentedControl!
    @IBOutlet var dateOfBirthday: UITextField!
    @IBOutlet var height: UITextField!
    @IBOutlet var weight: UITextField!
    @IBOutlet var activity: UITextField!
    @IBOutlet var goal: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTextFields()
    }
}

private extension ProfileViewController {
    func initTextFields() {
        dateOfBirthday.delegate = self
        height.delegate = self
        weight.delegate = self
        activity.delegate = self
        goal.delegate = self
    }
}

extension ProfileViewController: UITextFieldDelegate {
    
}
