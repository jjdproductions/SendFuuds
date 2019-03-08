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
        print(users)
        
        
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
    
    @IBAction func onAdd(_ sender: Any) {
        var user = PFUser.current()
        var friends = user?["friends"] as! [String]
        friends.append()
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddFriendCell", for: indexPath) as! AddFriendCell
        cell.nameLabel?.text = users[indexPath.row]
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
