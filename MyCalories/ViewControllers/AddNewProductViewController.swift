//
//  AddNewProductViewController.swift
//  MyCalories
//
//  Created by Иван Семикин on 14/04/2024.
//

import UIKit

final class AddNewProductViewController: UIViewController {
    
    @IBOutlet var addBarButtonItem: UIBarButtonItem!
    
    @IBOutlet var nameTF: UITextField!
    @IBOutlet var proteinTF: UITextField!
    @IBOutlet var fatsTF: UITextField!
    @IBOutlet var carbohydratesTF: UITextField!
    @IBOutlet var caloriesTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func addBarButtonItemAction(_ sender: UIBarButtonItem) {
    }
}
