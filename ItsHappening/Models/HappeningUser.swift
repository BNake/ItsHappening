//
//  HappeningUser.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/26/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import Foundation

struct HappeningUser: FireStoreSaveable {
    
    let id: String
    let username: String
    let email: String
    var firstName: String?
    var lastName: String?
    var profileImageUrl: String?
    var idsOfEventsLiked:  [String] = []
    
    // FIX ME: should be stored in private in firebase
    var idsOfUsersFollowing: [String] = []
    var idsOfUsersWhoRequestedToFollowYou: [String] = []
    var idsOfUsersWhoYouRequestedToFollow: [String] = []
    
    func getFullName() -> String {
        let first = firstName ?? ""
        let last = lastName ?? ""
        return "\(first) \(last)"
    }
    
    init(dict: [String: AnyObject]) {
        self.id = dict["id"] as? String ?? ""
        self.email = dict["email"] as? String ?? ""
        self.username = dict["username"] as? String ?? ""
        self.firstName = dict["firstName"] as? String
        self.lastName = dict["lastName"] as? String
        self.profileImageUrl = dict["profileImageUrl"] as? String
        
    }
    
    init(id: String,
         username: String,
         email: String,
         firstName: String?,
         lastName: String?,
         profileImageUrl: String?) {
        
        self.id = id
        self.username = username
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.profileImageUrl = profileImageUrl
        
    }
    
}
