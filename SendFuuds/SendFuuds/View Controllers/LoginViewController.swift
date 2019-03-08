//
//  LoginViewController.swift
//  SendFuuds
//
//  Created by Justin Leong on 3/4/19.
//  Copyright © 2019 JoshTav. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLogin(_ sender: Any) {
        let user = username.text!
        let pass = password.text!
        
        PFUser.logInWithUsername(inBackground: user, password: pass) { (user, error) in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    @IBAction func onSignup(_ sender: Any) {
        let user = PFUser()
        user.username = username.text
        user.password = password.text
        //user["friends"] = [String]()
        let userInfo = PFObject(className: "userInfo")
        
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
            } else {
                print("Error: \(String(describing: error?.localizedDescription))")
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
