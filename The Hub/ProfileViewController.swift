//
//  ProfileViewController.swift
//  The Hub
//
//  Created by Harold  on 3/31/18.
//  Copyright © 2018 Harold . All rights reserved.
//

import UIKit
import Firebase
import PCLBlurEffectAlert

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchUser()
        profileImageView.layer.cornerRadius = 120 / 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOutDidTapped(_ sender: Any) {
        
        
        let alert = PCLBlurEffectAlert.Controller(title: "Log Out", message: "Are you sure you want to log out", effect: UIBlurEffect(style: .light), style: .actionSheet)
        //  let alertBtn = PCLBlurEffectAlert.Action(title: "Okay", style: .default, handler: )
        
        let alertNahButton = PCLBlurEffectAlert.Action(title: "Nah!", style: .default, handler: { (alert) in
            
        })
        
        let alertYepButton = PCLBlurEffectAlert.Action(title: "Yep!", style: .default, handler: { (alert) in
            self.logOut()
            print("**** YEP")
        })
        alert.addAction(alertYepButton)
        alert.addAction(alertNahButton)
        
        alert.configure(buttonTextColor: [.default: UIColor(red: 58/255, green: 57/255, blue: 42/255, alpha: 1)])
        // R58 G57 B42
        alert.configure(cornerRadius: 10.0)
        alert.configure(backgroundColor: UIColor(red: 58/255, green: 57/255, blue: 42/255, alpha: 1))
        alert.configure(titleColor: .white)
        alert.configure(messageColor: .white)
        alert.configure(buttonBackgroundColor: .white)
        alert.show()
    }
    
    fileprivate func fetchUser() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(uid)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot.value)
            guard let userInfo = snapshot.value as? [String: Any] else { return }
            
            guard let username = userInfo["username"] as? String else { return }
            guard let profiePic = userInfo["profileImageUrl"] as? String else { return }
            
            let imageUrl = URL(string: profiePic)
            self.profileImageView.af_setImage(withURL: imageUrl!)
            self.usernameLabel.text = username
            
            
        }
    }
    

    
    func logOut(){
        
        do {
            try Auth.auth().signOut()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC") as UIViewController
            
            present(loginVC, animated: true, completion: nil)
            
        } catch let signOutError {
            print("sign Out Error ", signOutError)
        }
        
    
    }
    
    

}
