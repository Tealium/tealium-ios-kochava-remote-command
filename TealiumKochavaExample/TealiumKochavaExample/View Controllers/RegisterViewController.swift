//
//  RegisterViewController.swift
//  TealiumKochavaExample
//
//  Copyright © 2019 Tealium. All rights reserved.
//

import UIKit

// Image Credit: https://www.flaticon.com/authors/flat-icons 🙏
class RegisterViewController: UIViewController {

    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TealiumHelper.trackScreen(self, name: "register")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        password.isSecureTextEntry = true
        fullName.delegate = self
        username.delegate = self
        password.delegate = self
    }

    @IBAction func onRegister(_ sender: Any) {
        guard let fullNameText = fullName.text, !fullNameText.isEmpty,
              let usernameText = username.text, !usernameText.isEmpty,
              let passwordText = password.text, !passwordText.isEmpty else {
            showAlert(title: "Error", message: "Please fill in all fields")
            return
        }
        
        // Generate different registration methods for testing
        let registrationMethods = ["email", "facebook", "google", "apple", "twitter", "phone"]
        let randomMethod = registrationMethods.randomElement() ?? "email"
        
        let userId = "USER_\(Int.random(in: 1000...9999))"
        
        // Additional user data for testing
        let userData: [String: Any] = [
            RegisterViewController.fullName: fullNameText,
            "age": Int.random(in: 18...65),
            "country": "Poland",
            "registration_source": "app",
            "marketing_consent": Bool.random()
        ]
        
        // Use enhanced method from TealiumHelper
        TealiumHelper.trackRegistration(userId: userId, method: randomMethod, userData: userData)
        
        // Additional data for tracking
        let registrationData: [String: Any] = [
            RegisterViewController.customerId: userId,
            RegisterViewController.signUpMethod: randomMethod,
            RegisterViewController.fullName: fullNameText,
            "username": usernameText,
            "registration_timestamp": Date().timeIntervalSince1970,
            "device_type": "iOS",
            "app_version": Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
        ]
        
        TealiumHelper.trackEvent(title: "user_register", data: registrationData)
        
        showAlert(title: "Success", message: "Account created successfully for \(fullNameText)!")
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

}

extension RegisterViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        fullName.resignFirstResponder()
        username.resignFirstResponder()
        password.resignFirstResponder()
    }
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

extension RegisterViewController {
    static let customerId = "customer_id"
    static let signUpMethod = "signup_method"
    static let fullName = "customer_full_name"
}
