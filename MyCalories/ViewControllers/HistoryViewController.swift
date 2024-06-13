//
//  HistoryViewController.swift
//  MyCalories
//
//  Created by Иван Семикин on 15/04/2024.
//

import UIKit
import RealmSwift

protocol HistoryViewControllerDelegate: AnyObject {
    func updateTableView()
}

final class HistoryViewController: UIViewController {
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var infoOfRowsInTable: UILabel!
    @IBOutlet var emptyLabel: UILabel!
    @IBOutlet var shadowTableViewView: UIView!
    @IBOutlet var extendingNavigationBarView: UIView!
    
    private let storageManager = StorageManager.shared
    private let hiddenTextField = UITextField(frame: .zero)
    private let datePicker = UIDatePicker()
    private var history: Results<History>!
    
    weak var delegate: MainScreenDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .clear
        view.addSubview(hiddenTextField)
        setDatePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        storageManager.fetchHistory { [unowned self] historyData in
            history = historyData
            emptyLabel.isHidden = history.isEmpty ? false : true
            updateEmptyLabel()
            tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.updateProgressBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationVC = segue.destination as? UINavigationController else { return }
        guard let editWeightVC = navigationVC.topViewController as? EditWeightViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            editWeightVC.choosedProduct = history[indexPath.section].productList[indexPath.row]
        default:
            editWeightVC.choosedWater = history[indexPath.section].waterList[indexPath.row]
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        editWeightVC.delegate = self
    }
    
    @IBAction func calendarBarButtonItemAction(_ sender: UIBarButtonItem) {
        hiddenTextField.becomeFirstResponder()
    }
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        infoOfRowsInTable.text = sender.selectedSegmentIndex == 0 ? String.pfckCal : String.ml
        updateEmptyLabel()
        tableView.reloadData()
    }
}

// MARK: - Private Methods
private extension HistoryViewController {
    func setupUI() {
        shadowTableViewView.setShadow(
            cornerRadius: 15,
            shadowColor: .black,
            shadowOffset: CGSize(width: 0, height: 2),
            shadowRadius: 6,
            shadowOpacity: 0.3
        )
        
        extendingNavigationBarView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 50)
    }
    
    func setDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale.current
        
        hiddenTextField.inputView = datePicker
        hiddenTextField.inputAccessoryView = createToolbar(
            title: String.done,
            isCancelSelector: true,
            selector: #selector(doneButtonPressed)
        )
    }
    
    @objc func doneButtonPressed() {
        let choosedDate = Calendar.current.startOfDay(for: datePicker.date)
        storageManager.fetchHistory {[unowned self] historyData in
            history = historyData.filter("date == %@", choosedDate)
            tableView.reloadData()
        }
        
        updateEmptyLabel()
        hiddenTextField.resignFirstResponder()
    }
    
    func updateEmptyLabel() {
        var hasData = false
        switch segmentedControl.selectedSegmentIndex {
        case 0: // Питание
            // Проверяем, есть ли продукты в любой из историй
            hasData = history?.contains(where: { $0.productList.count > 0 }) ?? false
        case 1: // Вода
            // Проверяем, есть ли записи о воде в любой из историй
            hasData = history?.contains(where: { $0.waterList.count > 0 }) ?? false
        default:
            break
        }
        
        emptyLabel.isHidden = hasData
    }
    
    func sectionHasData(in section: Int) -> Bool {
        if segmentedControl.selectedSegmentIndex == 0 {
            return !history[section].productList.isEmpty
        } else {
            return !history[section].waterList.isEmpty
        }
    }
}

// MARK: - HistroryProductsViewControllerDelegate
extension HistoryViewController: HistoryViewControllerDelegate {
    func updateTableView() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "historyProductsCell", for: indexPath) as? HistoryProductViewCell else {
                return UITableViewCell()
            }
            
            if segmentedControl.selectedSegmentIndex == 0 {
                let product = history[indexPath.section].productList[indexPath.row]
                cell.configure(with: product)
            } else {
                let water = history[indexPath.section].waterList[indexPath.row]
                cell.configure(with: water)
            }
            
            return cell
    }
    
    // Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .white
        let label = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.bounds.width - 30, height: 16))
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .colorApp
        
        label.text = Date.dateToString(history[section].date)
        header.addSubview(label)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        sectionHasData(in: section) ? 20 : 0
    }
    
    // Footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width - 16, height: 30))
        let label = UILabel(frame: footerView.bounds)
        footerView.backgroundColor = .white
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
            label.text = String.total + "  \(Int(protein)) / \(Int(fats)) / \(Int(carbohydrates))   \(Int(calories))"
        default:
            let mls = history.waterList.reduce(0) { $0 + $1.ml }
            label.text = String.total + " \(mls) " + String.ml
        }
        
        footerView.addSubview(label)
        
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        sectionHasData(in: section) ? 20 : 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let product = history[indexPath.section].productList[indexPath.row]
            showAlert(withTitle: product.name, message: String.weight + " \(product.weight) " + String.g)
        default:
            showAlert(withTitle: String.selectTheOption, message: "")
        }
    }
}

// MARK: - UIAlertController
private extension HistoryViewController {
    func showAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let editButton = UIAlertAction(title: String.editWeight, style: .default) { [unowned self] _ in
            performSegue(withIdentifier: "ToEditPosition", sender: nil)
        }
        
        let deleteButton = UIAlertAction(title: String.delete, style: .destructive) { [unowned self] _ in
            handleDeleteAction()
        }
        
        let cancelButton = UIAlertAction(title: String.cancel, style: .cancel) { [unowned self] _ in
            handleCancelAction()
        }
        
        alert.addAction(editButton)
        alert.addAction(deleteButton)
        alert.addAction(cancelButton)
        present(alert, animated: true)
    }
    
    func handleDeleteAction() {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let historyItem = history[indexPath.section]
        
        if segmentedControl.selectedSegmentIndex == 0 {
            let productToDelete = historyItem.productList[indexPath.row]
            showAlertDelete(for: productToDelete.name, inTableView: tableView) { [unowned self] in
                deleteItemFromHistory(productToDelete, fromHistory: historyItem, at: indexPath)
            }
        } else {
            let waterToDelete = historyItem.waterList[indexPath.row]
            showAlertDelete(for: "", inTableView: tableView) { [unowned self] in
                deleteItemFromHistory(waterToDelete, fromHistory: historyItem, at: indexPath)
            }
        }
    }
    
    func handleCancelAction() {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func deleteItemFromHistory<T: Object>(_ item: T, fromHistory history: History, at indexPath: IndexPath) {
        if item is Product {
            if history.productList.count == 1 && history.waterList.isEmpty {
                storageManager.deleteItemFromHistory(item, history: history)
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
            } else {
                storageManager.deleteItemFromHistory(item, history: history)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadSections(IndexSet(integer: indexPath.section), with: .fade)
            }
        } else if item is Water {
            if history.waterList.count == 1 && history.productList.isEmpty {
                storageManager.deleteItemFromHistory(item, history: history)
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
            } else {
                storageManager.deleteItemFromHistory(item, history: history)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadSections(IndexSet(integer: indexPath.section), with: .fade)
            }
        }
        
        updateEmptyLabel()
    }
}
