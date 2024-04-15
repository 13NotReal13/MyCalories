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
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension HistroryProductsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        historyProducts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        historyProducts[section].usedProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyProductsCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let product = historyProducts[indexPath.section].usedProducts[indexPath.row]
        
        content.text = product.name
        content.secondaryText = "\(Int(product.protein)) / \(Int(product.fats)) / \(Int(product.carbohydrates))   \(Int(product.calories))"
        cell.contentConfiguration = content
        
        return cell
    }
    
    // Header
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        Date.dateToString(historyProducts[section].date)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .boldSystemFont(ofSize: 18)
        header.layer.cornerRadius = 5
        header.textLabel?.textColor = .colorApp
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    // Footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let history = historyProducts[section]
        let protein = history.usedProducts.reduce(0) { $0 + $1.protein }
        let fats = history.usedProducts.reduce(0) { $0 + $1.fats }
        let carbohydrates = history.usedProducts.reduce(0) { $0 + $1.carbohydrates }
        let calories = history.usedProducts.reduce(0) { $0 + $1.calories }
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width - 16, height: 30))
        let label = UILabel(frame: footerView.bounds)
        label.textAlignment = .right
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .colorApp
        label.text = "Всего:  \(Int(protein)) / \(Int(fats)) / \(Int(carbohydrates))   \(Int(calories))"
        footerView.addSubview(label)
        
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
