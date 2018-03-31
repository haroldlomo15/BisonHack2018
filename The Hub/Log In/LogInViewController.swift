//
//  LogInViewController.swift
//  The Hub
//
//  Created by Harold  on 3/31/18.
//  Copyright © 2018 Harold . All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

  
    @IBAction func LogInDidTapped(_ sender: Any) {
    
        guard let email = emailTF.text, let password = passwordTF.text else{
            print("LogIn Form not valid")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error ?? "Sign in error")
                return
            }
            
            let HomeviewController = self.storyboard!.instantiateViewController(withIdentifier:"SetupVC") as UIViewController
            self.present(HomeviewController, animated: true, completion: nil)
            
            
            print("successfully log in with Email")
        }
        
    }
    
    
    
    
}
