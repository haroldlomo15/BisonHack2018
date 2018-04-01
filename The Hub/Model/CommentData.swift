//
//  CommentData.swift
//  The Hub
//
//  Created by Harold  on 3/31/18.
//  Copyright © 2018 Harold . All rights reserved.
//

import Foundation

struct CommentData {
    let username: String
    let profilePicUrl: String
    let creationDate: Date
    let commentText: String
    
    init(dictionary: [String:Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profilePicUrl = dictionary["profilePicUrl"] as? String ?? ""
        self.commentText = dictionary["commentText"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
        
    }
}
