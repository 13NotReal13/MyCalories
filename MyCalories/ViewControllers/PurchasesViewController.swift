//
//  PurchasesViewController.swift
//  MyCalories
//
//  Created by Иван Семикин on 28/05/2024.
//

import UIKit
import StoreKit
import TPInAppReceipt
import FirebaseAnalytics

enum Purchases {
    case annually
    case monthly
}

final class PurchasesViewController: UIViewController {
    
    @IBOutlet var annuallyView: UIView!
    @IBOutlet var monthlyView: UIView!
    
    @IBOutlet var titleAnnuallyLabel: UILabel!
    @IBOutlet var descriptionAnnuallyLabel: UILabel!
    @IBOutlet var priceAnnuallyLabel: UILabel!
    @IBOutlet var pricePerMonthAnnuallyLabel: UILabel!
    @IBOutlet var expirationDateAnnuallyLabel: UILabel!
    
    @IBOutlet var titleMonthlyLabel: UILabel!
    @IBOutlet var descriptionMonthlyLabel: UILabel!
    @IBOutlet var priceMonthlyLabel: UILabel!
    @IBOutlet var pricePerMonthMonthlyLabel: UILabel!
    @IBOutlet var expirationDateMonthlyLabel: UILabel!
    
    @IBOutlet var purchaseButton: UIButton!
    @IBOutlet var termsOfUseButton: UIButton!
    @IBOutlet var privacyButton: UIButton!
    
    @IBOutlet var arrowImageView: UIImageView!
    
    private var purchasesManager = PurchasesManager.shared
    private var productsDict = [String: SKProduct]()
    private var choosedPurchase: Purchases = .annually
    private var activeSubscription: InAppPurchase?
    
    private var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setActivityIndicator()
        activityIndicator.startAnimating()
        purchasesManager.onProductsLoaded = {
            DispatchQueue.main.async { [unowned self] in
                updateProductDict()
                setupUI()
                updateLabels()
            }
        }
        
        purchasesManager.onPurchaseComplete = { [unowned self] success in
            if success {
                activeSubscription = purchasesManager.activeSubscription()
                hasActivePurchase()
            }
        }
        
        purchasesManager.setupIAP()
        Analytics.logEvent("purchase_screen_open", parameters: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activeSubscription = purchasesManager.activeSubscription()
        hasActivePurchase()
    }
    
    @IBAction func purchaseButtonAction() {
        let productID = choosedPurchase == .annually ? "Annually" : "Monthly"
        if let product = productsDict[productID] {
            purchasesManager.buy(product: product)
        }
        Analytics.logEvent("purchase_buy_button_tapped", parameters: nil)
    }
    
    @IBAction func restorePurchasesButtonAction() {
        purchasesManager.setupIAP()
        purchasesManager.restorePurchases()
        Analytics.logEvent("purchase_restore_button_tapped", parameters: nil)
        
        guard let activeSubscription = activeSubscription,
            let expirationDate = activeSubscription.subscriptionExpirationDate else {
            showAlertRestorePurchases(
                withTitle: "Восстановить покупки",
                andMessage: "Запрос на восстановление покупок с вашего AppleID отправлен."
            )
            return
        }
        
        let formatDate = Date.dateToString(expirationDate)
        showAlertRestorePurchases(
            withTitle: "Подписка восстановлена",
            andMessage: "Дата истечения: \(formatDate)"
        )
        hasActivePurchase()
    }
    
    @IBAction func closeBarButtonItemAction(_ sender: UIBarButtonItem) {
        Analytics.logEvent("purchase_screen_close", parameters: nil)
        dismiss(animated: true)
    }
    
    @IBAction func privacyButtonAction() {
        if let url = URL(string: "https://13notreal13.github.io/support-page/privacy.html") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func termsOfUseButtonAction() {
        if let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") {
            UIApplication.shared.open(url)
        }
    }
    
    private func updateProductDict() {
        productsDict = Dictionary(uniqueKeysWithValues: purchasesManager.products.map { ($0.productIdentifier, $0) } )
    }
}

// MARK: - Setup UI
private extension PurchasesViewController {
    func setupUI() {
        setShadowsForViews()
        setPurchasesViews()
        animateArrow()
        setPrivacyButton()
        setTermsOfUseButton()
        setTapsGestureForChoosedPurshase()
        
        activityIndicator.stopAnimating()
        annuallyView.isHidden = false
        monthlyView.isHidden = false
    }
    
    func setShadowsForViews() {
        let annuallyShadowOpacity: Float = choosedPurchase == .annually ? 0.4 : 0.0
        let monthlyShadowOpacity: Float = choosedPurchase == .monthly ? 0.4 : 0.0
        
        annuallyView.setShadow(
            cornerRadius: 20,
            shadowColor: .black,
            shadowOffset: CGSize(width: 0, height: 0),
            shadowRadius: 4,
            shadowOpacity: annuallyShadowOpacity
        )
        
        monthlyView.setShadow(
            cornerRadius: 20,
            shadowColor: .black,
            shadowOffset: CGSize(width: 0, height: 0),
            shadowRadius: 4,
            shadowOpacity: monthlyShadowOpacity
        )
    }
    
    func setPurchasesViews() {
        annuallyView.backgroundColor = choosedPurchase == .annually ? .textColorApp : .white
        titleAnnuallyLabel.textColor = choosedPurchase == .annually ? .white : .black
        priceAnnuallyLabel.textColor = choosedPurchase == .annually ? .white : .black
        pricePerMonthAnnuallyLabel.textColor = choosedPurchase == .annually ? .white : .black
        
        monthlyView.backgroundColor = choosedPurchase == .monthly ? .textColorApp : .white
        titleMonthlyLabel.textColor = choosedPurchase == .monthly ? .white : .black
        priceMonthlyLabel.textColor = choosedPurchase == .monthly ? .white : .black
        pricePerMonthMonthlyLabel.textColor = choosedPurchase == .monthly ? .white : .black
    }
    
    func setPrivacyButton() {
        let attributes: [NSAttributedString .Key: Any] =
            [
                .font: UIFont.systemFont(ofSize: 13),
                .foregroundColor: UIColor.black,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        
        let attributedString = NSAttributedString(string: "Политика конфиденциальности", attributes: attributes)
        
        privacyButton.setAttributedTitle(attributedString, for: .normal)
    }
    
    func setTermsOfUseButton() {
        let attributes: [NSAttributedString .Key: Any] =
            [
                .font: UIFont.systemFont(ofSize: 13),
                .foregroundColor: UIColor.black,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        
        let attributedString = NSAttributedString(string: "Условия использования", attributes: attributes)
        
        termsOfUseButton.setAttributedTitle(attributedString, for: .normal)
    }
    
    func hasActivePurchase() {
        guard let activeSubscription = activeSubscription,
            let expirationDate = activeSubscription.subscriptionExpirationDate else { return }
        let formatDate = "Истекает: \(Date.dateToString(expirationDate))"
        
        choosedPurchase = activeSubscription.productIdentifier == "Annually" ? .annually : .monthly
        
        annuallyView.alpha = activeSubscription.productIdentifier == "Annually" ? 1 : 0.4
        expirationDateAnnuallyLabel.isHidden = activeSubscription.productIdentifier == "Annually" ? false : true
        expirationDateAnnuallyLabel.text = activeSubscription.productIdentifier == "Annually" ? formatDate : ""
        expirationDateAnnuallyLabel.textColor = .white
        
        monthlyView.alpha = activeSubscription.productIdentifier == "Monthly" ? 1 : 0.4
        expirationDateMonthlyLabel.isHidden = activeSubscription.productIdentifier == "Monthly" ? false : true
        expirationDateMonthlyLabel.text = activeSubscription.productIdentifier == "Monthly" ? formatDate : ""
        expirationDateMonthlyLabel.textColor = .white
        
        purchaseButton.isEnabled = false
        setupUI()
    }
    
    func updateLabels() {
        for (identifier, product) in productsDict {
            switch identifier {
            case "Annually":
                titleAnnuallyLabel.text = product.localizedTitle
                descriptionAnnuallyLabel.text = product.localizedDescription
                priceAnnuallyLabel.text = formatPrice(product)
                pricePerMonthAnnuallyLabel.text = formatPricePerMonth(product) + " / мес."
            case "Monthly":
                titleMonthlyLabel.text = product.localizedTitle
                descriptionMonthlyLabel.text = product.localizedDescription
                priceMonthlyLabel.text = formatPrice(product)
                pricePerMonthMonthlyLabel.text = formatPricePerMonth(product) + " / мес."
            default:
                break
            }
        }
    }
    
    func formatPrice(_ product: SKProduct) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price) ?? ""
    }
    
    func formatPricePerMonth(_ product: SKProduct) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        let pricePerMonth = product.price.dividing(by: NSDecimalNumber(value: product.productIdentifier == "Annually" ? 12 : 1))
        return formatter.string(from: pricePerMonth) ?? ""
    }
    
    func setTapsGestureForChoosedPurshase() {
        let tapGestureForAnnually = UITapGestureRecognizer(
            target: self,
            action: #selector(handlerTapGestureAnnually)
        )
        annuallyView.addGestureRecognizer(tapGestureForAnnually)
        
        let tapGestureForMonthly = UITapGestureRecognizer(
            target: self,
            action: #selector(handlerTapGestureMonthly)
        )
        monthlyView.addGestureRecognizer(tapGestureForMonthly)
    }
    
    @objc func handlerTapGestureAnnually() {
        if annuallyView.alpha == 1 {
            choosedPurchase = .annually
            print(choosedPurchase)
            setupUI()
        }
    }
    
    @objc func handlerTapGestureMonthly() {
        if monthlyView.alpha == 1 {
            choosedPurchase = .monthly
            print(choosedPurchase)
            setupUI()
        }
    }
    
    func setActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    func animateArrow() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.autoreverse, .repeat]) { [unowned self] in
            arrowImageView.transform = CGAffineTransform(translationX: -19, y: 0)
        }
    }
}

private extension PurchasesViewController {
    func showAlertRestorePurchases(withTitle title: String, andMessage message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let okButton = UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(okButton)
        present(alert, animated: true)
    }
}
