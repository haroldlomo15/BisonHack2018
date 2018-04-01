//
//  ShareMusic.swift
//  The Hub
//
//  Created by Harold  on 3/31/18.
//  Copyright © 2018 Harold . All rights reserved.
//

import Foundation


struct ShareMusic {
    let username: String
    let profileImage: String
    let artist: String
    let title: String
    
    let creationDate: Date
    
    init(dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImage = dictionary["profileImageUrl"] as? String ?? ""
        self.artist = dictionary["artist"] as? String ?? ""
        self.title = dictionary["title"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
        
    }
}
