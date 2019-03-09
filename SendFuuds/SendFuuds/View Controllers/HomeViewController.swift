//
//  HomeViewController.swift
//  SendFuuds
//
//  Created by Justin Leong on 3/4/19.
//  Copyright © 2019 JoshTav. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var foods = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let user = PFUser.current()
        let currentUser = PFQuery(className: "userInfo")
        currentUser.whereKey("username", equalTo: user!.username!)
        var userObject = PFObject(className: "userInfo")
        do{
            let userObjects = try currentUser.findObjects()
            for u in userObjects {
                userObject = u
            }
        } catch {
            print("error")
        }
        var friends = userObject["friends"] as! [String]
        friends.append(user!.username!)
        print(friends)
        
        let query = PFQuery(className: "Foods")
        query.includeKeys(["owner", "description"])
        query.whereKey("owner", containedIn: friends)
        query.limit = 20
        
        query.findObjectsInBackground { (foods, error) in
            if foods != nil {
                self.foods = foods!
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.window?.rootViewController = loginViewController
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell") as! FoodCell
        let food = foods[indexPath.row]
        
        cell.ownerLabel.text = food["owner"] as? String
        
        cell.descLabel.text = food["description"] as? String
        
        let imageFile = food["image"] as! PFFileObject
        let urlString = imageFile.url!
        
        let url = URL(string: urlString)!
        
        cell.photoView.af_setImage(withURL: url)
        
        return cell
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
