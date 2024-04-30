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
    
    weak var delegate: MainScreenDelegate?
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.updateProgressBar()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("1")
        guard let editWeightVC = segue.destination as? EditWeightViewController else { return }
        print("2")
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        print("3")
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            editWeightVC.choosedProduct = historyProducts[indexPath.section].usedProducts[indexPath.row]
        default:
            editWeightVC.choosedWater = historyOfWater[indexPath.section].waterList[indexPath.row]
        }
    }
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        infoOfRowsInTable.text = sender.selectedSegmentIndex == 0 ? "Б / Ж / У  Ккал" : "Мл."
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
            let product = historyProducts[indexPath.section].usedProducts[indexPath.row]
            
            cell?.productNameLabel.text = product.name
            cell?.bguLabel?.text = "\(Int(product.protein)) / \(Int(product.fats)) / \(Int(product.carbohydrates))"
            cell?.caloriesLabel.text = String(Int(product.calories))
        default:
            let water = historyOfWater[indexPath.section].waterList[indexPath.row]
            cell?.productNameLabel.text = Date.timeToString(water.date)
            cell?.bguLabel?.text = ""
            cell?.caloriesLabel.text = String(water.ml)
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
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let product = historyProducts[indexPath.section].usedProducts[indexPath.row]
            showAlert(withTitle: product.name, message: "Вес: \(product.weight) г.")
        default:
            let water = historyOfWater[indexPath.section].waterList[indexPath.row]
                showAlert(withTitle: "Выберите нужный вариант", message: "")
        }
    }
}

extension HistroryProductsViewController {
    private func showAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let editButton = UIAlertAction(title: "Изменить вес", style: .default) { [unowned self] _ in
            performSegue(withIdentifier: "ToEditPosition", sender: nil)
        }
        
        let deleteAcrtion = UIAlertAction(title: "Удалить", style: .destructive) { [unowned self] _ in
            showAskToDeleteAlert()
        }
        
        let cancelButton = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addAction(editButton)
        alert.addAction(deleteAcrtion)
        alert.addAction(cancelButton)
        present(alert, animated: true)
    }
    
    private func showAskToDeleteAlert() {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let alert = UIAlertController(
            title: segmentedControl.selectedSegmentIndex == 0
                ? "Вы уверены, что хотите удалить - \(historyProducts[indexPath.section].usedProducts[indexPath.row].name)?"
                : "Вы уверены, что хотите удалить?",
            message: "",
            preferredStyle: .alert
        )
        
        let yesButton = UIAlertAction(title: "Да", style: .destructive) { [unowned self] _ in
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                let history = historyProducts[indexPath.section]
                let productToDelete = history.usedProducts[indexPath.row]
                if history.usedProducts.count == 1 {
                    storageManager.deleteProductFromHistory(productToDelete, fromHistory: history)
                    tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
                } else {
                    storageManager.deleteProductFromHistory(productToDelete, fromHistory: history)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            default:
                let history = historyOfWater[indexPath.section]
                let waterToDelete = history.waterList[indexPath.row]
                if history.waterList.count == 1 {
                    storageManager.deleteWaterFromHistory(waterToDelete, fromHistory: history)
                    tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
                } else {
                    storageManager.deleteWaterFromHistory(waterToDelete, fromHistory: history)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
        
        let noButton = UIAlertAction(title: "Нет", style: .cancel)
        
        alert.addAction(yesButton)
        alert.addAction(noButton)
        present(alert, animated: true)
    }
}
