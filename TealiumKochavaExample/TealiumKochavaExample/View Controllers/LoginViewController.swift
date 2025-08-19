//
//  LoginViewController.swift
//  TealiumKochavaExample
//
//  Copyright © 2019 Tealium. All rights reserved.
//

import UIKit

// Image Credit: https://www.flaticon.com/authors/freepik 🙏
class LoginViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TealiumHelper.trackScreen(self, name: "login")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        password.isSecureTextEntry = true
        username.delegate = self
        password.delegate = self
    }
    
    @IBAction func onLogin(_ sender: Any) {
        guard let usernameText = username.text, !usernameText.isEmpty,
              let passwordText = password.text, !passwordText.isEmpty else {
            showAlert(title: "Error", message: "Please enter username and password")
            return
        }
        
        // Generate different login scenarios for testing
        let loginMethods = ["email", "facebook", "google", "apple", "twitter"]
        let randomMethod = loginMethods.randomElement() ?? "email"
        
        let userId = "USER_\(Int.random(in: 1000...9999))"
        
        // Use enhanced method from TealiumHelper
        TealiumHelper.trackLogin(userId: userId, method: randomMethod)
        
        // Additional data for testing
        let additionalData: [String: Any] = [
            LoginViewController.customerId: userId,
            LoginViewController.signUpMethod: randomMethod,
            LoginViewController.username: usernameText,
            "login_timestamp": Date().timeIntervalSince1970,
            "device_type": "iOS",
            "app_version": Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
        ]
        
        TealiumHelper.trackEvent(title: "user_login", data: additionalData)
        
        showAlert(title: "Success", message: "Successfully logged in as \(usernameText)")
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        username.resignFirstResponder()
        password.resignFirstResponder()
    }
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

extension LoginViewController {
    static let customerId = "customer_id"
    static let signUpMethod = "signup_method"
    static let username = "username"
}
