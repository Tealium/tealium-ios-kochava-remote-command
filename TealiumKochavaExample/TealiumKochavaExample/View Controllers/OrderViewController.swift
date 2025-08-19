//
//  OrderViewController.swift
//  TealiumKochavaExample
//
//  Copyright © 2019 Tealium. All rights reserved.
//

import UIKit

// Image Credit: https://www.flaticon.com/authors/smashicons 🙏
class OrderViewController: UIViewController {
    
    @IBOutlet weak var orderNumber: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let orderId = "ORD\(Int.random(in: 10000...99999))"
        let orderTotal = Double.random(in: 50...500)
        
        orderNumber.text = "Thank you! Your order number: \(orderId)\nTotal: $\(String(format: "%.2f", orderTotal))"
        
        // Track purchase automatically when order screen loads
        trackPurchaseComplete(orderId: orderId, total: orderTotal)
        
        // Add button to test additional purchase scenarios
        setupPurchaseTestButton()
    }
    
    private func trackPurchaseComplete(orderId: String, total: Double) {
        // Generate sample products for testing
        let products = generateSampleProducts()
        
        // Use enhanced purchase tracking method
        TealiumHelper.trackPurchase(orderId: orderId, total: total, currency: "USD", products: products)
        
        // Additional purchase event data
        let purchaseEventData: [String: Any] = [
            OrderViewController.orderId: orderId,
            OrderViewController.orderTotal: total,
            OrderViewController.orderCurrency: "USD",
            "payment_method": ["credit_card", "paypal", "apple_pay", "google_pay"].randomElement() ?? "credit_card",
            "shipping_method": ["standard", "express", "overnight"].randomElement() ?? "standard",
            "discount_applied": Bool.random(),
            "discount_amount": Bool.random() ? Double.random(in: 5...50) : 0,
            "tax_amount": total * 0.08, // 8% tax
            "shipping_cost": Double.random(in: 0...15),
            "item_count": products?.count ?? 1,
            "customer_type": ["new", "returning", "vip"].randomElement() ?? "returning",
            "purchase_timestamp": Date().timeIntervalSince1970
        ]
        
        TealiumHelper.trackEvent(title: "order", data: purchaseEventData)
    }
    
    private func generateSampleProducts() -> [[String: Any]] {
        let productNames = ["Fridge", "Vacuum", "Blender", "Toaster", "Iron"]
        let categories = ["appliances", "kitchen", "cleaning"]
        
        return productNames.prefix(Int.random(in: 1...3)).map { name in
            return [
                "product_name": name,
                "product_id": "PROD_\(Int.random(in: 1000...9999))",
                "product_category": categories.randomElement() ?? "appliances",
                "product_quantity": Int.random(in: 1...3),
                "product_unit_price": Double.random(in: 20...200),
                "product_brand": ["Samsung", "LG", "Whirlpool", "KitchenAid"].randomElement() ?? "Generic"
            ]
        }
    }
    
    private func setupPurchaseTestButton() {
        let testButton = UIButton(type: .system)
        testButton.setTitle("Test Another Purchase", for: .normal)
        testButton.backgroundColor = UIColor.systemBlue
        testButton.setTitleColor(.white, for: .normal)
        testButton.layer.cornerRadius = 8
        testButton.addTarget(self, action: #selector(testAnotherPurchase), for: .touchUpInside)
        
        view.addSubview(testButton)
        testButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            testButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            testButton.widthAnchor.constraint(equalToConstant: 200),
            testButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func testAnotherPurchase() {
        let orderId = "TEST_\(Int.random(in: 10000...99999))"
        let orderTotal = Double.random(in: 25...750)
        
        trackPurchaseComplete(orderId: orderId, total: orderTotal)
        
        let alert = UIAlertController(title: "Test Purchase Tracked", 
                                    message: "Order \(orderId) with total $\(String(format: "%.2f", orderTotal)) has been tracked", 
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

}

extension OrderViewController {
    static let screenClass = "screen_class"
    static let orderId = "order_id"
    static let orderCurrency = "order_currency"
    static let orderTotal = "order_total"
}
