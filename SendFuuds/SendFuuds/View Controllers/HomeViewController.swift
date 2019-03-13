//
//  HomeViewController.swift
//  SendFuuds
//
//  Created by Justin Leong on 3/4/19.
//  Copyright © 2019 JoshTav. All rights reserved.
//

import UIKit
import Parse
import MessageInputBar

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let commentBar = MessageInputBar()
    var showsCommentBar = false
    
    var foods = [PFObject]()
    var selectedPost: PFObject!
    
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentBar.inputTextView.placeholder = "Add a comment..."
        commentBar.sendButton.title = "Send"
        commentBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        myRefreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        
        tableView.keyboardDismissMode = .interactive
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        let comment = PFObject(className: "Comments")
        comment["text"] = text
        comment["food"] = selectedPost
        comment["author"] = PFUser.current()!
        
        selectedPost.add(comment, forKey: "comments")
        
        selectedPost.saveInBackground { (success, error) in
            if success {
                print("comment saved")
            } else {
                print("error")
            }
        }
        self.loadPosts()
        
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    
    @objc func keyboardWillBeHidden(note: Notification) {
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    
    override var inputAccessoryView: UIView? {
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return showsCommentBar
    }
    
    @objc func refresh() {
        self.loadPosts()
        myRefreshControl.endRefreshing()
    }
    
    @objc func loadPosts() {
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
        var friends = userObject["friends"] as! [String]
        friends.append(user!.username!)
        
        let query = PFQuery(className: "Foods")
        query.includeKeys(["owner", "description", "image", "public", "comments", "comments.author"])
        //finding the all the keys that are contained in the Array Friends
        query.whereKey("owner", containedIn: friends)
        query.whereKey("public", equalTo: true)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.loadPosts()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "postSegue", sender: foods[indexPath.row])
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell") as! FoodCell
        let food = foods[indexPath.row]
        
        cell.ownerLabel.text = (food["owner"] as? String)! + ": "
        
        cell.descLabel.text = food["description"] as? String
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let expDateFormatted = formatter.string(from: food["date"] as! Date)
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "MM/dd/yyyy"
        let postDateFormatted = formatter2.string(from: food.createdAt as! Date)
        
        cell.postDateLabel.text = postDateFormatted
        cell.expDateLabel.text = expDateFormatted
        
        let imageFile = food["image"] as! PFFileObject
        let urlString = imageFile.url!
        
        let url = URL(string: urlString)!
        
        cell.photoView.af_setImage(withURL: url)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postSegue" {
            let food = sender
            let chatNav = segue.destination as! UINavigationController
            let chatViewController = chatNav.viewControllers.first as! ChatViewController
            chatViewController.food = food as! PFObject
        }
        
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
