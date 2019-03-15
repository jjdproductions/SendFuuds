//
//  ChatViewController.swift
//  SendFuuds
//
//  Created by Justin Leong on 3/12/19.
//  Copyright © 2019 JoshTav. All rights reserved.
//

import UIKit
import Parse
import MessageInputBar
import UserNotifications

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate  {

    @IBOutlet weak var tableView: UITableView!
    
    let commentBar = MessageInputBar()
    var showsCommentBar = false
    var food: PFObject!
    
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
        // Do any additional setup after loading the view.
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        let comment = PFObject(className: "Comments")
        comment["text"] = text
        comment["author"] = PFUser.current()!.username
        
        food.add(comment, forKey: "comments")
        
        food.saveInBackground { (success, error) in
            if success {
            }
        }
        self.loadPost()
        
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
        self.loadPost()
        myRefreshControl.endRefreshing()
    }
    
    @objc func loadPost() {
        let query = PFQuery(className: "Foods")
        query.includeKeys(["owner", "description", "image", "public", "comments", "comments.author"])
        query.whereKey("objectId", equalTo: food!.objectId as! String)
        
        query.findObjectsInBackground { (foundFood, error) in
            if foundFood != nil {
                for origFood in foundFood! {
                    self.food = origFood
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.loadPost()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let comments = (food["comments"] as? [PFObject]) ?? []
         
        if indexPath.row == comments.count + 1 {
            showsCommentBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let comments = (food["comments"] as? [PFObject]) ?? []
        return comments.count + 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comments = (food["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell") as! FoodCell
            
            
            cell.ownerLabel.text = (food["owner"] as? String)! + ": "
            
            cell.descLabel.text = food["description"] as? String
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            let expDateFormatted = formatter.string(from: food["date"] as! Date)
            let formatter2 = DateFormatter()
            formatter2.dateFormat = "MM/dd/yyyy"
            let postDateFormatted = formatter2.string(from: food.createdAt!)
            
            cell.postDateLabel.text = postDateFormatted
            cell.expDateLabel.text = expDateFormatted
            
            let imageFile = food["image"] as! PFFileObject
            let urlString = imageFile.url!
            
            let url = URL(string: urlString)!
            
            cell.photoView.af_setImage(withURL: url)
            
            return cell
            
        }
        else if indexPath.row <= comments.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            
            let comment = comments[indexPath.row - 1]
            cell.commentLabel.text = comment["text"] as? String
            
            let user = comment["author"] as! String
            cell.nameLabel.text = user
            
            return cell
            
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            
            return cell
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.window?.rootViewController = loginViewController
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
