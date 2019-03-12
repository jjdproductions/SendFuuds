//
//  ProfileViewController.swift
//  SendFuuds
//
//  Created by Justin Leong on 3/11/19.
//  Copyright © 2019 JoshTav. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var foods = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func reload()
    {
        let query = PFQuery(className: "Foods")
        query.includeKeys(["owner", "description", "date", "image"])
        //finding the all the keys that are contained in the Array Friends
        query.whereKey("owner", equalTo: PFUser.current()!.username!)
        //display newer posts on top
        query.order(byDescending: "createdAt")
        query.limit = 20
        
        query.findObjectsInBackground { (foods, error) in
            if foods != nil {
                self.foods = foods!
                self.tableView.reloadData()
            }
        }
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let query = PFQuery(className: "Foods")
        query.includeKeys(["owner", "description", "date", "image"])
        //finding the all the keys that are contained in the Array Friends
        query.whereKey("owner", equalTo: PFUser.current()!.username!)
        //display newer posts on top
        query.order(byDescending: "createdAt")
        query.limit = 20
        
        query.findObjectsInBackground { (foods, error) in
            if foods != nil {
                self.foods = foods!
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }
    
    @objc func removeFood(sender:UIButton) {
        //creating a varaible for current PFUser
        let user = PFUser.current()
        
        let center = sender.center
        let point = sender.superview!.convert(center, to:self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: point)
        let cell = self.tableView.cellForRow(at: indexPath!) as! ProfileCell

        let id = cell.objectIdLabel.text
        
        let find = PFQuery(className: "Foods")
        let findFood = find.whereKey("owner", equalTo: user!.username!)
        findFood.findObjectsInBackground(block: { (object, error) in
            for food in object! {
                let foodId = food.objectId
                if id == foodId {
                    let notification = food["notification"] as! PFObject
                    notification.deleteInBackground(block: { (success, error) in
                        if success {
                            food.deleteInBackground(block: { (success, error) in
                                if success {
                                    self.reload()
                                    self.dismiss(animated: true, completion: nil)
                                }
                            })
                        }
                    })
                }
            }
        })
        
        // update button text when user presses add button
        tableView.reloadData()
    }
    
    @objc func makePublic(sender:UIButton) {
        //creating a varaible for current PFUser
        let user = PFUser.current()
        
        let center = sender.center
        let point = sender.superview!.convert(center, to:self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: point)
        let cell = self.tableView.cellForRow(at: indexPath!) as! ProfileCell
        
        let id = cell.objectIdLabel.text
        
        let find = PFQuery(className: "Foods")
        let findFood = find.whereKey("owner", equalTo: user!.username!)
        findFood.findObjectsInBackground(block: { (object, error) in
            for food in object! {
                let foodId = food.objectId
                if id == foodId {
                    food["public"] = true
                    food.saveInBackground(block: { (success, error) in
                        if success {
                            self.reload()
                        }
                    })
                }
            }
        })
        
        // update button text when user presses add button
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
        let food = foods[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let dateFormatted = formatter.string(from: food["date"] as! Date)
        
        
        cell.expirationLabel.text = "Expiration Date: " + dateFormatted
        
        cell.descLabel.text = food["description"] as? String
        
        cell.objectIdLabel.text = food.objectId
        
        let imageFile = food["image"] as! PFFileObject
        let urlString = imageFile.url!
        
        let url = URL(string: urlString)!
        
        cell.foodImage.af_setImage(withURL: url)
        
        cell.removeButton.addTarget(self, action: #selector(removeFood), for: .touchUpInside)
        
        if (food["public"] as! Bool) == true
        {
            cell.publicButton.setTitle("Already public", for: .normal)
            cell.publicButton.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            cell.publicButton.isUserInteractionEnabled = false
            
        }
        else
        {
            cell.publicButton.addTarget(self, action: #selector(makePublic), for: .touchUpInside)
        }
        
        
        return cell
    }

    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.window?.rootViewController = loginViewController
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
