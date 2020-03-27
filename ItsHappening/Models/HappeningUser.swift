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
    
    
}
