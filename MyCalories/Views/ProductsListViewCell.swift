//
//  ProductsListViewCell.swift
//  MyCalories
//
//  Created by Иван Семикин on 08/04/2024.
//

import UIKit

final class ProductsListViewCell: UITableViewCell {

    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var proteinProductLabel: UILabel!
    @IBOutlet var fatsProductLabel: UILabel!
    @IBOutlet var carbohydratesProductLabel: UILabel!
    @IBOutlet var caloriesProductLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
