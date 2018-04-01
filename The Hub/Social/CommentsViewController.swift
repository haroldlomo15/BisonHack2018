//
//  CommentsViewController.swift
//  The Hub
//
//  Created by Harold  on 3/31/18.
//  Copyright © 2018 Harold . All rights reserved.
//

import UIKit
import Firebase

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var comments = [CommentData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.alwaysBounceVertical = true
        tableView.keyboardDismissMode = .interactive
        
   
        fetchComments()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (0 > scrollView.contentOffset.y) {
            // move up
            print("Up")
        }
        else if (0 < scrollView.contentOffset.y) {
            // move down
             print("Down")
        }
        
       
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
       
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.comments.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.item)
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        let comment = comments[indexPath.row]
        cell.usernameLabel.text = comment.username
        cell.commentLabel.text = comment.commentText
        cell.timeStampLabel.text = comment.creationDate.timeAgoDisplay()
        
        guard let profileUrl = URL(string: comment.profilePicUrl) else { return cell }
        
        cell.profileImageView.af_setImage(withURL: profileUrl)
        return cell
    }
    
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.black, for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        containerView.addSubview(submitButton)
        
        
        submitButton.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 0)
        
        containerView.addSubview(self.commentTextField)
        self.commentTextField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        let lineSeparatorView = UIView()
        lineSeparatorView.backgroundColor = UIColor.gray
        containerView.addSubview(lineSeparatorView)
        lineSeparatorView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        return containerView
    }()
    
    
    let commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Comment"
        return textField
    }()
    
    @objc func handleSubmit() {
        if commentTextField.text != "" {
            sendComment()
            
        }
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func fetchComments() {
        
        let ref = Database.database().reference().child("comments")
        
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            let commentsData = CommentData.init(dictionary: dictionary)
            print(commentsData.commentText)
            
            self.comments.append(commentsData)
            self.tableView.reloadData()
            self.scrollToBottom()
            
        }) { (err) in
            print("Failed to fetch ordered posts:", err)
        }
    }
    
    
    func sendComment() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("users").child(uid)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot.value)
            guard let userInfo = snapshot.value as? [String: Any] else { return }
            
            guard let username = userInfo["username"] as? String else { return }
            guard let profiePic = userInfo["profileImageUrl"] as? String else { return }
            
            
            let userShareRef = Database.database().reference().child("comments").childByAutoId()
            
            
            let commentValues = ["username": username, "profilePicUrl": profiePic, "creationDate" :  Date().timeIntervalSince1970, "commentText": self.commentTextField.text ?? ""] as [String : Any]
            
            userShareRef.updateChildValues(commentValues) { (err, ref) in
                if let err = err {
                    //Enable Button Interaction
                    print("Failed to save post to DB", err)
                    return
                }
                
                print("Successfully saved post to DB")
                self.commentTextField.text = ""
                
            }
        }
    }


}
