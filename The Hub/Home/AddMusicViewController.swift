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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
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
                    self.sharedSuccessfulLabel()
                }
            }
          
        }
    }
    
    func sharedSuccessfulLabel(){
        DispatchQueue.main.async {
            let savedLabel = UILabel()
            savedLabel.text = "Successfully Added"
            savedLabel.font = UIFont.boldSystemFont(ofSize: 18)
            savedLabel.textColor = .white
            savedLabel.numberOfLines = 0
            savedLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
            savedLabel.textAlignment = .center
            savedLabel.layer.cornerRadius = 20
            savedLabel.clipsToBounds = true
            savedLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
            //     savedLabel.center = self.center
            savedLabel.center = self.view.center
            self.view.addSubview(savedLabel)
            
            
            savedLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                
                savedLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
                
            }, completion: { (completed) in
                //completed
                
                UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    
                    savedLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                    savedLabel.alpha = 0
                    
                }, completion: { (_) in
                    
                    savedLabel.removeFromSuperview()
                   
                    
                })
                
            })
        }
    }
    

}
