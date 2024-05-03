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
    private var history: Results<History>!
    
    weak var delegate: MainScreenDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        storageManager.fetchHistory { [unowned self] historyData in
            history = historyData
            tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.updateProgressBar()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let editWeightVC = segue.destination as? EditWeightViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            editWeightVC.choosedProduct = history[indexPath.section].productList[indexPath.row]
        default:
            editWeightVC.choosedWater = history[indexPath.section].waterList[indexPath.row]
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
        history.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0: 
            history[section].productList.isEmpty ? 0 : history[section].productList.count
        default:
            history[section].waterList.isEmpty ? 0 : history[section].waterList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "historyProductsCell",
            for: indexPath
        ) as? HistoryProductViewCell
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let product = history[indexPath.section].productList[indexPath.row]
            
            cell?.productNameLabel.text = product.name
            cell?.bguLabel?.text = "\(Int(product.protein)) / \(Int(product.fats)) / \(Int(product.carbohydrates))"
            cell?.caloriesLabel.text = String(Int(product.calories))
        default:
            let water = history[indexPath.section].waterList[indexPath.row]
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
        
        label.text = Date.dateToString(history[section].date)
        header.addSubview(label)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionHasData = segmentedControl.selectedSegmentIndex == 0
            ? !history[section].productList.isEmpty
            : !history[section].waterList.isEmpty
        return sectionHasData ? 25 : 0
    }
    
    // Footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width - 16, height: 30))
        let label = UILabel(frame: footerView.bounds)
        label.textAlignment = .right
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .colorApp
        
        let history = history[section]
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let protein = history.productList.reduce(0) { $0 + $1.protein }
            let fats = history.productList.reduce(0) { $0 + $1.fats }
            let carbohydrates = history.productList.reduce(0) { $0 + $1.carbohydrates }
            let calories = history.productList.reduce(0) { $0 + $1.calories }
            label.text = "Всего:  \(Int(protein)) / \(Int(fats)) / \(Int(carbohydrates))   \(Int(calories))"
        default:
            let mls = history.waterList.reduce(0) { $0 + $1.ml }
            label.text = "Всего: \(mls) мл."
        }
        
        footerView.addSubview(label)
        
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sectionHasData = segmentedControl.selectedSegmentIndex == 0
            ? !history[section].productList.isEmpty
            : !history[section].waterList.isEmpty
        return sectionHasData ? 20 : 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let product = history[indexPath.section].productList[indexPath.row]
            showAlert(withTitle: product.name, message: "Вес: \(product.weight) г.")
        default:
            showAlert(withTitle: "Выберите нужный вариант", message: "")
        }
    }
}

// MARK: - UIAlertController
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
                ? "Вы уверены, что хотите удалить - \(history[indexPath.section].productList[indexPath.row].name)?"
                : "Вы уверены, что хотите удалить?",
            message: "",
            preferredStyle: .alert
        )
        
        let yesButton = UIAlertAction(title: "Да", style: .destructive) { [unowned self] _ in
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                let history = history[indexPath.section]
                let productToDelete = history.productList[indexPath.row]
                if history.productList.count == 1 && history.waterList.count == 0 {
                    storageManager.deleteProductFromHistory(productToDelete, fromHistory: history)
                    tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
                } else {
                    storageManager.deleteProductFromHistory(productToDelete, fromHistory: history)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.reloadSections(IndexSet(integer: indexPath.section), with: .fade)
                }
            default:
                let history = history[indexPath.section]
                let waterToDelete = history.waterList[indexPath.row]
                if history.waterList.count == 1 && history.productList.count == 0 {
                    storageManager.deleteWaterFromHistory(waterToDelete, fromHistory: history)
                    tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
                } else {
                    storageManager.deleteWaterFromHistory(waterToDelete, fromHistory: history)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.reloadSections(IndexSet(integer: indexPath.section), with: .fade)
                }
            }
        }
        
        let noButton = UIAlertAction(title: "Нет", style: .cancel)
        
        alert.addAction(yesButton)
        alert.addAction(noButton)
        present(alert, animated: true)
    }
}
