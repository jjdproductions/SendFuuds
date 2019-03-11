//
//  NotificationViewController.swift
//  SendFuuds
//
//  Created by Justin Leong on 3/9/19.
//  Copyright © 2019 JoshTav. All rights reserved.
//

import UIKit
import Parse

class NotificationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var notifications = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let query = PFQuery(className: "Notifications")
        query.whereKey("username", equalTo: PFUser.current()!.username!)
        query.findObjectsInBackground { (notifications, error) in
            if notifications != nil {
                self.notifications = notifications!
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
    
    @IBAction func onSend(_ sender: Any) {
        self.tabBarController?.selectedIndex = 3
    }
    
    @IBAction func onRemove(_ sender: Any) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationCell
        let notification = notifications[indexPath.row]
        
        if (notification["day"] as! Date) <= Date() {
            let imageFile = notification["image"] as! PFFileObject
            let urlString = imageFile.url!
            
            let url = URL(string: urlString)!
            
            cell.foodImage.af_setImage(withURL: url)
            
            cell.notificationLabel.text = (notification["text"] as! String)
        }
        
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
