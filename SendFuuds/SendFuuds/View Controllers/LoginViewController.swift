//
//  LoginViewController.swift
//  SendFuuds
//
//  Created by Justin Leong on 3/4/19.
//  Copyright © 2019 JoshTav. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.delegate = self
        username.returnKeyType = .done
        password.delegate = self
        password.returnKeyType = .done
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func onLogin(_ sender: Any) {
        let username = self.username.text!
        let password = self.password.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
            else {
                // Alert user that they inputted an incorrect username or password:
                let alert = UIAlertController(title: "Incorrect Username or Password",
                                              message: "Please Try Again",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
    
    // Helper function for checking user password when signing up
    func checkPassword() -> Bool {
        
        let passwordInput = password.text
        
        // Password must contain at least 1 capital letter, lowercase letter, digit, and symbol.
        // Must be at least 8 characters long
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$&*]).{8,}$"
        
        let range = NSRange(location: 0, length: passwordInput!.utf16.count)
        let regex = try! NSRegularExpression(pattern: passwordRegex)
        
        if regex.firstMatch(in: passwordInput!, options: [], range: range) != nil {
            return true
        }
        else {
            let alert = UIAlertController(title: "Please input a stronger password",
                                          message: "Must be at least 8 characters long and contain at least 1 captial letter, lowercase letter, digit, and symbol.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
            return false
        }
    }
    
    @IBAction func onSignup(_ sender: Any) {
        let user = PFUser()
        user.username = username.text
        let userInfo = PFObject(className: "userInfo")
        if username.text == "" {
            let alert = UIAlertController(title: "Error occured when signing up",
                                          message: "Please input a username",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }

        let passwordSuccess = checkPassword()
        
        if passwordSuccess {
            user.password = password.text!
            userInfo["username"] = username.text!
            userInfo["friends"] = [String]()
            
            userInfo.saveInBackground {
                (success, error) in
                if success {
                }
            }
            
            user.signUpInBackground { (success, error) in
                if success {
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
                else {
                    let alert = UIAlertController(title: "Error occured when signing up",
                                                  message: "Please use a unique username and password",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        username.text = ""
        password.text = ""
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
