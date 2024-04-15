//
//  HistroryProductsViewController.swift
//  MyCalories
//
//  Created by Иван Семикин on 15/04/2024.
//

import UIKit
import RealmSwift

final class HistroryProductsViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    private let storageManager = StorageManager.shared
    private var historyProducts: Results<HistoryOfProducts>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storageManager.fetchHistoryOfProducts { [unowned self] products in
            historyProducts = products
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension HistroryProductsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        historyProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyProductsCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let history = historyProducts[indexPath.row]
        
        let protein = history.usedProducts.reduce(0) { $0 + $1.protein }
        let fats = history.usedProducts.reduce(0) { $0 + $1.fats }
        let carbohydrates = history.usedProducts.reduce(0) { $0 + $1.carbohydrates }
        let calories = history.usedProducts.reduce(0) { $0 + $1.calories }
        
        content.text = Date.dateToString(history.date)
        content.secondaryText = "\(Int(protein)) / \(Int(fats)) / \(Int(carbohydrates))   \(Int(calories))"
        cell.contentConfiguration = content
        
        return cell
    }
}
