//
//  AccountViewController.swift
//  TealiumFirebaseExample
//
//  Created by Christina Sund on 7/18/19.
//  Copyright © 2019 Christina. All rights reserved.
//

import UIKit

// Image Credit: https://www.flaticon.com/authors/freepik and
// https://www.flaticon.com/authors/monkik 🙏
class AccountViewController: UIViewController {

    @IBOutlet weak var offersImage: UIImageView!
    @IBOutlet weak var groupNameTextField: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TealiumHelper.trackScreen(self, name: "account")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupNameTextField.delegate = self
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
    }
    
    @objc func share() {
        TealiumHelper.trackEvent(title: "share", data: [AccountViewController.contentType: "account screen", AccountViewController.shareId: "accqwe123"])
        let vc = UIActivityViewController(activityItems: ["Account"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    @IBAction func showOfferTapped(_ sender: UIButton) {
        TealiumHelper.trackEvent(title: "adview", data: [AccountViewController.productId: ["12"], AccountViewController.productQuantity: ["1"], AccountViewController.productName: ["vacuum"], AccountViewController.productCategory: ["household"]])
        offersImage.image = UIImage(named: "bank")
        let ac = UIAlertController(title: "Offers", message: "You have a new offer, please shop and get 10% off a vacuum! This will be applied at checkout when you purchase this item.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @IBAction func searchGroupTapped(_ sender: UIButton) {
        guard let name = groupNameTextField.text else { return }
        var results = 0
        var title = "Oops!"
        var message = "Please enter a group name to search for."
        if name != "" {
            title = "Nice!"
            results = Int.random(in: 1...10)
            message = "Found \(results) groups with the name: \(name)"
        }
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            TealiumHelper.trackEvent(title: "search", data: [AccountViewController.searchKeyword: name,
                                                             AccountViewController.searchResults: results])
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
}

extension AccountViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        groupNameTextField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

extension AccountViewController {
    static let contentType = "content_type"
    static let shareId = "share_id"
    static let productId = "product_id"
    static let productQuantity = "product_quantity"
    static let productName = "product_name"
    static let productCategory = "product_category"
    static let searchKeyword = "search_keyword"
    static let searchResults = "search_results"
}
