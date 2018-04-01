//
//  SetupHomeViewController.swift
//  The Hub
//
//  Created by Harold  on 3/31/18.
//  Copyright © 2018 Harold . All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage
class SetupHomeViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var goButton: UIButton!
    
    @IBOutlet weak var uniqueIDTf: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchUser()
        goButton.layer.cornerRadius = 50 / 2
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 120 / 2
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func goButtonDidTapped(_ sender: Any) {
      //  postUniqueID()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabVC = storyboard.instantiateViewController(withIdentifier: "MainVC") as! UITabBarController
        self.present(mainTabVC, animated: true, completion: nil)  
    }
    
    func postUniqueID() {
        guard let uniqueId = uniqueIDTf.text else { return }
         let userShareRef = Database.database().reference().child("music")
        let value:[String:Any] = ["hello":"world"]
        userShareRef.updateChildValues(value) { (error, ref) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainTabVC = storyboard.instantiateViewController(withIdentifier: "MainVC") as! UITabBarController
                self.present(mainTabVC, animated: true, completion: nil)
            }
        }
    }
    
    var user: User?
    fileprivate func fetchUser() {
        
        let uid = Auth.auth().currentUser?.uid ?? ""
        
        //guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .childAdded) { (snapshot) in
            let dicty = snapshot.value
            let urlimage = URL(string: dicty as! String)
            self.profileImageView.af_setImage(withURL: urlimage!)
            
        }
    }


}
