//
//  SearchViewController.swift
//  SendFuuds
//
//  Created by Justin Leong on 3/7/19.
//  Copyright © 2019 JoshTav. All rights reserved.
//

import UIKit
import Parse

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var all_users = [String]()
    var users = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        self.loadData()
        // Do any additional setup after loading the view.
    }
    
    func loadData() {
        let query = PFUser.query()
        do{
            let queryObjects = try query!.findObjects()
            for object in queryObjects {
                // get all users except for the current user, since users shouldn't be able to find themselves
                if object["username"] as! String != PFUser.current()?["username"] as! String
                {
                    self.all_users.append(object["username"] as! String)
                    self.users.append(object["username"] as! String)
                }
            }
        } catch {
            print("error")
        }
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func onProfile(_ sender: Any) {
        self.performSegue(withIdentifier: "profileSegue", sender: nil)
    }
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.window?.rootViewController = loginViewController
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    @objc func addFriend(sender:UIButton) {
        //creating a varaible for current PFUser
        let user = PFUser.current()
        //Grabing the userInfo table
        let query = PFQuery(className: "userInfo")
        //Grabbing the tuple where the user is equal to the current user
        query.whereKey("username", equalTo: user!.username!)
        //Grabbing the userInfor table
        var userObject = PFObject(className: "userInfo")
        do{
            let userObjects = try query.findObjects()
            for u in userObjects {
                userObject = u
            }
        } catch {
            print("error")
        }
        //accessing friend's col
        var friends = userObject["friends"] as! [String]
        //StackOverFlow
        let center = sender.center
        let point = sender.superview!.convert(center, to:self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: point)
        let cell = self.tableView.cellForRow(at: indexPath!) as! AddFriendCell
        //
        let friendName = cell.nameLabel.text
        //if the frend is not in the Array of User's Friends then you can add
        //to the table
        if friends.contains(friendName!) == false {
            friends.append(friendName!)
        }
        //updating the database
        userObject["friends"] = friends
        userObject.saveInBackground()
        
        //
        let find = PFQuery(className: "userInfo")
        let findFriend = find.whereKey("username", equalTo: friendName!)
        //finding user info object of the friend
        findFriend.findObjectsInBackground(block: { (object, error) in
            for friend in object! {
                var newFriends = friend["friends"] as! [String]
                if newFriends.contains(user!.username!) == false {
                    newFriends.append(user!.username!)
                    friend["friends"] = newFriends
                    friend.saveInBackground()
                }
            }
        })
        
        // update button text when user presses add button
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddFriendCell", for: indexPath) as! AddFriendCell
        cell.nameLabel?.text = users[indexPath.row]
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
        //this is an array that contains all the current user's friends and the current user
        let friends = userObject["friends"] as! [String]
        if friends.contains(users[indexPath.row])
        {
            //disable button if already friends
            cell.addButton.setTitle("Already friends", for: .normal)
            cell.addButton.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            cell.addButton.isUserInteractionEnabled = false
            
        }
        else
        {
            //enable button to add friends
            cell.addButton.addTarget(self, action: #selector(addFriend), for: .touchUpInside)
        }
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        users = searchText.isEmpty ? all_users : all_users.filter({(dataString: String) -> Bool in
            return dataString.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        tableView.reloadData()
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
