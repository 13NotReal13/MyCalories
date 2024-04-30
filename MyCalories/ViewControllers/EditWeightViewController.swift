//
//  EditPositionFromHistory.swift
//  MyCalories
//
//  Created by Иван Семикин on 30/04/2024.
//

import UIKit

final class EditWeightViewController: UIViewController {
    
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var weightTF: UITextField!
    
    var choosedProduct: Product?
    var choosedWater: Water?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weightTF.placeholder = choosedProduct != nil ? "г." : "мл."
        productNameLabel.text = choosedProduct != nil ? choosedProduct?.name : ""
        
        weightTF.text = choosedProduct != nil 
            ? String(choosedProduct?.weight ?? 0.0)
            : String(choosedWater?.ml ?? 0)
    }
}
