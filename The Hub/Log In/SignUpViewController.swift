//
//  SignUpViewController.swift
//  The Hub
//
//  Created by Harold  on 3/31/18.
//  Copyright © 2018 Harold . All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.layer.cornerRadius = 100 / 2
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelDidTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker = UIImage()
        
        if let editedImage = info["UIImagePickerContollerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
            
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        let selectedImage = selectedImageFromPicker
        profileImageView.image = selectedImage
        
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func signUpDidTapped(_ sender: Any) {
        guard let email = emailTF.text, let password = passwordTF.text, let name = usernameTF.text else {
            print("LogIn Form not valid")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error ?? "FiRAuth.createUser not working")
                return
            }
            
            guard let uid = user?.uid else {
                print("Uid error")
                return
            }
            
            let fileName = NSUUID().uuidString //gives unique uid name variables
            let storageRef = Storage.storage().reference().child("profile_pictures").child("\(fileName).jpg")
            
            if let profileImage = self.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        print(error ?? "Default: Problem with storing profileImage")
                        return
                    }
                    
                    //getting url of profile image and store that and the username into firebase Database
                    guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else { return }
                    
                    print("Successfully uploaded profile image:", profileImageUrl)
                    
                    guard let uid = user?.uid else { return }
                    
                    let dictionaryValues = ["username": name, "profileImageUrl": profileImageUrl]
                    let values = [uid: dictionaryValues]
                    
                    Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                        
                        if let err = err {
                            print("Failed to save user info into db:", err)
                            return
                        }
                        
                        print("Successfully saved user info to db")
                        
                        let HomeviewController = self.storyboard!.instantiateViewController(withIdentifier:"SetupVC") as UIViewController
                        self.present(HomeviewController, animated: true, completion: nil)
                        
                        print("successfully Registered with Email")
                        
                    })
                    
                    
                })
            }
            
        }
    
    }
    

}
