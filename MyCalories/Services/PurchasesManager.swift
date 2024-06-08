//
//  PurchasesManager.swift
//  MyCalories
//
//  Created by Иван Семикин on 28/05/2024.
//

import Foundation
import StoreKit
import TPInAppReceipt
import FirebaseAnalytics

final class PurchasesManager: NSObject {
    static let shared = PurchasesManager()
    
    var onProductsLoaded: (() -> Void)?
    var onPurchaseComplete: ((Bool) -> Void)?
    var products: [SKProduct] = []
    
    private let paymentQueue = SKPaymentQueue.default()
    
    private override init() {}
    
    func setupIAP() {
        paymentQueue.add(self)
        loadProducts()
    }
    
    private func loadProducts() {
        let productIDs: Set<String> = ["Monthly", "Annually"]
        
        let request = SKProductsRequest(productIdentifiers: productIDs)
        request.delegate = self
        request.start()
    }
    
    func activeSubscription() -> InAppPurchase? {
        do {
            let receipt = try InAppReceipt.localReceipt()
            let purchases = receipt.purchases
//            print("purchases: \(purchases)")
            
            for purchase in purchases {
                if let expiryDate = purchase.subscriptionExpirationDate,
                   expiryDate > Date() && purchase.cancellationDate == nil {
//                    print("Subscription \(purchase.productIdentifier) is active.")
                    return purchase
                }
            }
        } catch {
            print("Error parsing receipt: \(error)")
        }
        
        return nil
    }
}

// MARK: - SKProductsRequestDelegate
extension PurchasesManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
        
        if products.isEmpty {
            print("Products are not available in the App Store")
        } else {
            for product in products {
                print("\(product.localizedTitle): \(product.priceLocale.currencySymbol ?? "")\(product.price)")
            }
            onProductsLoaded?()
        }
    }
}

// MARK: - SKPaymentTransactionObserver
extension PurchasesManager: SKPaymentTransactionObserver {
    func buy(product: SKProduct) {
        let payment = SKPayment(product: product)
        paymentQueue.add(payment)
    }
    
    func restorePurchases() {
//        print("Attempting to restore purchases")
        paymentQueue.restoreCompletedTransactions()
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
//                print("Purchased: \(transaction.payment.productIdentifier)")
                onPurchaseComplete?(true)
                paymentQueue.finishTransaction(transaction)
            case .restored:
//                print("Restored: \(transaction.payment.productIdentifier)")
                onPurchaseComplete?(true)
                paymentQueue.finishTransaction(transaction)
            case .failed:
                if let error = transaction.error as NSError? {
                    print("Transaction failed: \(error.localizedDescription)")
                }
                onPurchaseComplete?(true)
                paymentQueue.finishTransaction(transaction)
            default:
//                print("Other transaction state")
                break
            }
        }
    }
}
