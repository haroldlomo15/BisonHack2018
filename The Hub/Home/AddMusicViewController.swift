//
//  AddMusicViewController.swift
//  The Hub
//
//  Created by Harold  on 3/31/18.
//  Copyright © 2018 Harold . All rights reserved.
//

import UIKit
import Firebase

class AddMusicViewController: UIViewController {

    
    @IBOutlet weak var artistTf: UITextField!
    
    @IBOutlet weak var titleTf: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func addButtonDidTapped(_ sender: Any) {
        postMusic()
    
    }
    
    
  
    
    func postMusic() {
        
        
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(uid)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let userInfo = snapshot.value as? [String: Any] else { return }
            guard let username = userInfo["username"] as? String else { return }
            guard let profiePic = userInfo["profileImageUrl"] as? String else { return }
        
            guard let title = self.titleTf.text else { return }
            guard let artist = self.artistTf.text else { return }
            let userShareRef = Database.database().reference().child("music").childByAutoId()
            
            
            
            let value = ["username": username,"profileImageUrl":profiePic, "title": title, "artist": artist, "creationDate": Date().timeIntervalSince1970] as [String : Any]
            userShareRef.updateChildValues(value) { (error, ref) in
                if error != nil {
                    print(error?.localizedDescription)
                } else {
                    //Successfully added
                }
            }
        
        
        
        
        }
        
        
        
        
       
      

    }
    

}
