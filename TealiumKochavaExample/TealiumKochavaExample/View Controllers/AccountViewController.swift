//
//  AccountViewController.swift
//  TealiumKochavaExample
//
//  Copyright © 2019 Tealium. All rights reserved.
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
        
        // Create more buttons for testing Kochava functions
        setupTestButtons()
    }
    
    private func setupTestButtons() {
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        let testButton = UIBarButtonItem(title: "Test", style: .plain, target: self, action: #selector(showTestMenu))
        
        tabBarController?.navigationItem.rightBarButtonItems = [shareButton, testButton]
    }
    
    @objc func showTestMenu() {
        let alert = UIAlertController(title: "Test Kochava Functions", 
                                    message: "Choose function to test", 
                                    preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Test Sleep Tracker (Enable)", style: .default) { _ in
            TealiumHelper.testSleepTracker(enabled: true)
            self.showAlert(title: "Sleep Tracker", message: "Sleep Tracker has been enabled")
        })
        
        alert.addAction(UIAlertAction(title: "Test Sleep Tracker (Disable)", style: .default) { _ in
            TealiumHelper.testSleepTracker(enabled: false)
            self.showAlert(title: "Sleep Tracker", message: "Sleep Tracker has been disabled")
        })
        
        alert.addAction(UIAlertAction(title: "Test Invalidate", style: .destructive) { _ in
            TealiumHelper.testInvalidate()
            self.showAlert(title: "Invalidate", message: "Kochava SDK has been invalidated")
        })
        
        alert.addAction(UIAlertAction(title: "Test Identity Link", style: .default) { _ in
            let userId = "TEST_USER_\(Int.random(in: 1000...9999))"
            TealiumHelper.trackEvent(title: "sendidentitylink", data: [
                "identity_link_ids": [
                    "userID": userId,
                    "email": "test@example.com",
                    "customerNumber": "CUST\(Int.random(in: 1000...9999))"
                ]
            ])
            self.showAlert(title: "Identity Link", message: "Identity Link sent for user: \(userId)")
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // For iPad
        if let popover = alert.popoverPresentationController {
            popover.barButtonItem = tabBarController?.navigationItem.rightBarButtonItems?.last
        }
        
        present(alert, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc func share() {
        TealiumHelper.trackEvent(title: "share", data: [AccountViewController.contentType: "account screen", AccountViewController.shareId: "accqwe123"])
        let vc = UIActivityViewController(activityItems: ["Account"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    @IBAction func showOfferTapped(_ sender: UIButton) {
        let campaignId = "CAMP_\(Int.random(in: 1000...9999))"
        let networkNames = ["Google Ads", "Facebook", "Instagram", "TikTok", "Snapchat"]
        let networkName = networkNames.randomElement() ?? "Google Ads"
        
        // Use enhanced method from TealiumHelper
        TealiumHelper.trackAdEvent(eventType: "show_offers", networkName: networkName, campaignId: campaignId)
        
        // Additional data for offers
        let offerData: [String: Any] = [
            "campaign_id": campaignId,
            "ad_network_name": networkName,
            "campaign": "vacuum_discount",
            "offer_type": "discount",
            "discount_percentage": 10,
            "product_category": "appliances",
            "offer_value": 50.0,
            "currency_code": "USD",
            "placement": "account_screen",
            "ad_format": "banner"
        ]
        
        TealiumHelper.trackEvent(title: "show_offers", data: offerData)
        
        // Simulate ad display
        offersImage.image = UIImage(named: "bank")
        let ac = UIAlertController(title: "Special Offer!", 
                                 message: "New offer from \(networkName)! Get 10% off vacuum cleaner! Discount will be applied at checkout.", 
                                 preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "View Offer", style: .default) { _ in
            // Track offer click
            TealiumHelper.trackAdEvent(eventType: "adclick", networkName: networkName, campaignId: campaignId)
        })
        ac.addAction(UIAlertAction(title: "Close", style: .cancel))
        present(ac, animated: true)
    }
    
    @IBAction func searchGroupTapped(_ sender: UIButton) {
        guard let name = groupNameTextField.text, !name.isEmpty else {
            showSearchAlert(title: "Error", message: "Please enter a group name to search for.", searchTerm: "", results: 0)
            return
        }
        
        let results = Int.random(in: 1...10)
        let searchData: [String: Any] = [
            AccountViewController.searchKeyword: name,
            AccountViewController.searchResults: results,
            "search_type": "group",
            "search_category": "social",
            "search_duration": Double.random(in: 0.5...3.0),
            "search_timestamp": Date().timeIntervalSince1970,
            "results_shown": results > 0
        ]
        
        TealiumHelper.trackEvent(title: "search", data: searchData)
        
        let title = results > 0 ? "Found!" : "No Results"
        let message = results > 0 ? "Found \(results) groups with name: \(name)" : "No groups found with name: \(name)"
        
        showSearchAlert(title: title, message: message, searchTerm: name, results: results)
    }
    
    private func showSearchAlert(title: String, message: String, searchTerm: String, results: Int) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if results > 0 {
            ac.addAction(UIAlertAction(title: "Join Group", style: .default) { _ in
                // Track group join
                TealiumHelper.trackEvent(title: "join_group", data: [
                    "group_name": searchTerm,
                    "group_size": Int.random(in: 10...1000),
                    "group_type": "public",
                    "join_method": "search"
                ])
                
                self.showJoinSuccessAlert(groupName: searchTerm)
            })
        }
        
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    private func showJoinSuccessAlert(groupName: String) {
        let alert = UIAlertController(title: "Success!", 
                                    message: "You joined the group: \(groupName)", 
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
