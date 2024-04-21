//
//  HistroryProductsViewController.swift
//  MyCalories
//
//  Created by Иван Семикин on 15/04/2024.
//

import UIKit
import RealmSwift

final class HistroryProductsViewController: UIViewController {
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var infoOfRowsInTable: UILabel!
    
    private let storageManager = StorageManager.shared
    private var historyProducts: Results<HistoryOfProducts>!
    private var historyOfWater: Results<HistoryOfWater>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storageManager.fetchHistoryOfProducts { [unowned self] products in
            historyProducts = products
            tableView.reloadData()
        }
        storageManager.fetchWaterList { [unowned self] water in
            historyOfWater = water
        }
    }
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension HistroryProductsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0: historyProducts.count
        default: historyOfWater.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0: historyProducts[section].usedProducts.count
        default: historyOfWater[section].waterList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "historyProductsCell",
            for: indexPath
        ) as? HistoryProductViewCell
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            infoOfRowsInTable.text = "Б  /  Ж  /  У  Ккал"
            
            let product = historyProducts[indexPath.section].usedProducts[indexPath.row]
            
            cell?.productNameLabel.text = product.name
            cell?.proteinLabel.text = String(Int(product.protein))
            cell?.fatsLabel.text = String(Int(product.fats))
            cell?.carbohydratesLabel.text = String(Int(product.carbohydrates))
            cell?.caloriesLabel.text = String(Int(product.calories))
            
            cell?.proteinLabel.isHidden = false
            cell?.fatsLabel.isHidden = false
            cell?.carbohydratesLabel.isHidden = false
            cell?.separatorOne.isHidden = false
            cell?.separatorTwo.isHidden = false
        default:
            infoOfRowsInTable.text = "Мл."
            
            let water = historyOfWater[indexPath.section].waterList[indexPath.row]
            cell?.productNameLabel.text = Date.timeToString(water.date)
            cell?.caloriesLabel.text = String(water.ml)
            
            cell?.proteinLabel.isHidden = true
            cell?.fatsLabel.isHidden = true
            cell?.carbohydratesLabel.isHidden = true
            cell?.separatorOne.isHidden = true
            cell?.separatorTwo.isHidden = true
        }
        
        return cell ?? UITableViewCell()
    }
    
    // Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .systemGray6
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: 25))
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .colorApp
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            label.text = Date.dateToString(historyProducts[section].date)
        default:
            label.text = Date.dateToString(historyOfWater[section].date)
        }
        header.addSubview(label)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    // Footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width - 16, height: 30))
        let label = UILabel(frame: footerView.bounds)
        label.textAlignment = .right
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .colorApp
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let history = historyProducts[section]
            let protein = history.usedProducts.reduce(0) { $0 + $1.protein }
            let fats = history.usedProducts.reduce(0) { $0 + $1.fats }
            let carbohydrates = history.usedProducts.reduce(0) { $0 + $1.carbohydrates }
            let calories = history.usedProducts.reduce(0) { $0 + $1.calories }
            label.text = "Всего:  \(Int(protein)) / \(Int(fats)) / \(Int(carbohydrates))   \(Int(calories))"
        default:
            let history = historyOfWater[section]
            let mls = history.waterList.reduce(0) { $0 + $1.ml }
            label.text = "Всего: \(mls) мл."
        }
        
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
