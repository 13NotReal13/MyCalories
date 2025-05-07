//
//  HistoryProductViewCell.swift
//  MyCalories
//
//  Created by Иван Семикин on 16/04/2024.
//

import UIKit

final class HistoryProductViewCell: UITableViewCell {
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var bguLabel: UILabel!
    @IBOutlet var caloriesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }
    
    func configure(with product: Product) {
        productNameLabel.text = product.name
        bguLabel.text = "\(Int(product.protein)) / \(Int(product.fats)) / \(Int(product.carbohydrates))"
        caloriesLabel.text = String(Int(product.calories))
    }
    
    func configure(with water: Water) {
        productNameLabel.text = Date.timeToString(water.date)
        bguLabel.text = ""
        caloriesLabel.text = String(water.ml)
    }
}
