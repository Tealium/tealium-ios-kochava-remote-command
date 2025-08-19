//
//  ProductViewController.swift
//  TealiumKochavaExample
//
//  Copyright © 2019 Tealium. All rights reserved.
//

import UIKit

// Image Credit: https://www.flaticon.com/authors/xnimrodx 🙏
class ProductViewController: UIViewController {

    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    var data = [String: Any]()
    var random: Int!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        random = Int.random(in: 0...1000)
        data[ProductViewController.productId] = ["PROD\(random!)"]
        data[ProductViewController.productCategory] = ["appliances"]
        NotificationCenter.default.addObserver(self, selector: #selector(showProduct(notification:)), name: Notification.Name(CategoryViewController.productClicked), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func changeQuantity(_ sender: UIStepper) {
        quantityLabel.text = String(Int(sender.value))
        data["product_quantity"] = [String(Int(sender.value))]
    }
    
    @IBAction func changeColor(_ sender: UISegmentedControl) {
        data["product_variant"] = ["\(String(describing: sender.titleForSegment(at: sender.selectedSegmentIndex)))-\(String(describing: random))"]
    }
    
    @IBAction func addToCart(_ sender: UIButton) {
        let productNameText = productName.text ?? "Unknown Product"
        let quantity = Int(quantityLabel.text ?? "1") ?? 1
        let priceText = productPrice.text?.replacingOccurrences(of: "$", with: "") ?? "0"
        let price = Double(priceText) ?? 0.0
        
        let ac = UIAlertController(title: "Added!", 
                                 message: "\(productNameText) has been added to your cart", 
                                 preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            // Rich data for add to cart
            let cartData: [String: Any] = [
                ProductViewController.productName: productNameText,
                ProductViewController.productQuantity: quantity,
                ProductViewController.productPrice: price,
                ProductViewController.productId: self.data[ProductViewController.productId] ?? "PROD_UNKNOWN",
                ProductViewController.productCategory: self.data[ProductViewController.productCategory] ?? "appliances",
                "product_variant": self.data["product_variant"] ?? "default",
                "currency_code": "USD",
                "item_added_from": "product_detail_page",
                "cart_value": price * Double(quantity),
                "total_cart_items": Int.random(in: 1...5),
                "user_segment": "premium",
                "add_to_cart_timestamp": Date().timeIntervalSince1970
            ]
            
            TealiumHelper.trackEvent(title: "cart_add", data: cartData)
        })
        ac.addAction(UIAlertAction(title: "Continue Shopping", style: .default) { _ in
            // Track continue shopping
            TealiumHelper.trackEvent(title: "continue_shopping", data: [
                "source": "add_to_cart_dialog",
                "product_added": productNameText
            ])
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @IBAction func AddToWishList(_ sender: UIButton) {
        let productNameText = productName.text ?? "Unknown Product"
        let quantity = Int(quantityLabel.text ?? "1") ?? 1
        let priceText = productPrice.text?.replacingOccurrences(of: "$", with: "") ?? "0"
        let price = Double(priceText) ?? 0.0
        
        let ac = UIAlertController(title: "Added to Wishlist!", 
                                 message: "\(productNameText) has been added to your wishlist", 
                                 preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            // Rich data for wishlist
            let wishlistData: [String: Any] = [
                "product_name": productNameText,
                "product_quantity": quantity,
                ProductViewController.productPrice: price,
                ProductViewController.productId: self.data[ProductViewController.productId] ?? "PROD_UNKNOWN",
                ProductViewController.productCategory: self.data[ProductViewController.productCategory] ?? "appliances",
                "product_variant": self.data["product_variant"] ?? "default",
                "currency_code": "USD",
                "wishlist_name": "main",
                "wishlist_size": Int.random(in: 1...20),
                "price_alert_enabled": Bool.random(),
                "in_stock": true,
                "wishlist_add_timestamp": Date().timeIntervalSince1970
            ]
            
            TealiumHelper.trackEvent(title: "wishlist_add", data: wishlistData)
        })
        
        ac.addAction(UIAlertAction(title: "View Wishlist", style: .default) { _ in
            // Track wishlist view
            TealiumHelper.trackEvent(title: "wishlist_view", data: [
                "source": "add_to_wishlist_dialog",
                "total_items": Int.random(in: 1...20)
            ])
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func showProduct(notification: Notification) {
        guard let productData = notification.userInfo else {
            return
        }
        if let name = productData[CategoryViewController.productName] as? String {
           productName.text = name
        } else {
            productName.text = "Fridge"
        }
        if let image = productData[CategoryViewController.productImageName] as? String {
            productImage.image = UIImage(named: image)
        } else {
            productImage.image = UIImage(named: "7-fridge")
        }
        if let price = productData[CategoryViewController.productPrice] as? String {
            productPrice.text = price
        } else {
             productPrice.text = "$100"
        }
        let formattedPrice = productPrice.text?.replacingOccurrences(of: "$", with: "")
        data[ProductViewController.productName] = [productName.text]
        data[ProductViewController.productPrice] = [formattedPrice]
        data["screen_class"] = "\(self.classForCoder)"
        TealiumHelper.trackView(title: "product", data: data)
    }
    
}

extension ProductViewController {
    static let productId = "product_id"
    static let productName = "product_name"
    static let productQuantity = "product_quantity"
    static let productVariant = "product_variant"
    static let productPrice = "product_price"
    static let productCategory = "product_category"
    static let screenClass = "screen_class"
}
