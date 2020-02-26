//
//  LoginViewController.swift
//  TealiumFirebaseExample
//
//  Created by Christina Sund on 7/18/19.
//  Copyright © 2019 Christina. All rights reserved.
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
        TealiumHelper.trackEvent(title: "user_login", data: [LoginViewController.customerId: "ABC123", LoginViewController.signUpMethod: "apple", LoginViewController.username: username.text!])
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
