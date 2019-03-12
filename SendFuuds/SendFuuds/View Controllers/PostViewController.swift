//
//  PostViewController.swift
//  SendFuuds
//
//  Created by Justin Leong on 3/6/19.
//  Copyright © 2019 JoshTav. All rights reserved.
//

import UIKit
import AlamofireImage
import Parse
import UserNotifications

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var descField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let picker = UIImagePickerController()
    
    var placeholder: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeholder = self.foodImageView.image
        picker.delegate = self
        descField.delegate = self
        descField.returnKeyType = .done
        // Do any additional setup after loading the view.
        

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    func postFood() {
        let food = PFObject(className: "Foods")
        
        food["date"] = datePicker.date
        
        let notifyInDays = -3
        var dateComponent = DateComponents()
        dateComponent.day = notifyInDays
        
        var notifyDay = Calendar.current.date(byAdding: dateComponent, to:datePicker.date)
        
        var trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        if notifyDay! > Date() {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 259200, repeats: false)
        }
        else {
            notifyDay = Date()
        }
        
        let notification = PFObject(className: "Notifications")
        
        notification["username"] = PFUser.current()!.username!
        notification["food"] = descField.text!
        notification["text"] = descField.text! + " is about to expire!!! Please take action!"
        notification["day"] = notifyDay
        
        let content = UNMutableNotificationContent()
        content.title = "Food about to expire!!"
        content.body = descField.text! + " is about to expire!!!"
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: "TestIdentifier", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        
        food["notifyDay"] = notifyDay
        food["description"] = descField.text!
        food["owner"] = PFUser.current()!.username!
        
        let imageData = foodImageView.image!.pngData()
        
        let file = PFFileObject(data: imageData!)
        
        food["image"] = file
        notification["image"] = file
        
        notification.saveInBackground {
            (success, error) in
            if success {
                print("Notification successfully saved")
            }
        }
        
        food.saveInBackground {
            (success, error) in
            if success {
                //self.dateField.text = ""
                self.descField.text = ""
                self.foodImageView.image = self.placeholder
                //tab bar is like an array
                self.tabBarController?.selectedIndex = 0
            }
            else {
                print("error")
            }
        }
    }
    
    @IBAction func onPost(_ sender: Any) {
        if foodImageView.image! == placeholder {
            let alert = UIAlertController(title: "No Image Found",
                                          message: "Please pick an image",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
            
        else {
            postFood()
        }
        
    }
    
    @IBAction func onImageTap(_ sender: Any) {

        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Gallery", style: .default, handler: { _ in
            self.openPhotoGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            picker.sourceType = .camera
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        }
            
        else {
            let alert  = UIAlertController(title: "ERROR", message: "No Camera Available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openPhotoGallary() {
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageAspectScaled(toFill: size)
        
        foodImageView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
