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

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var descField: UITextField!
    
    var placeholder: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeholder = self.foodImageView.image
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onPost(_ sender: Any) {
        let food = PFObject(className: "Foods")
        
        food["date"] = dateField.text!
        food["description"] = descField.text!
        food["owner"] = PFUser.current()!
        
        let imageData = foodImageView.image!.pngData()
        let file = PFFileObject(data: imageData!)
        
        food["image"] = file
        
        food.saveInBackground {
            (success, error) in
            if success {
                self.dateField.text = ""
                self.descField.text = ""
                self.foodImageView.image = self.placeholder
            }
            else {
                print("error")
            }
        }
    }
    
    
    @IBAction func onImageTap(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageAspectScaled(toFill: size)
        
        foodImageView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
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
