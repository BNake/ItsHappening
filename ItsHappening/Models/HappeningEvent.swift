//
//  Event.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/20/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import Foundation

enum EventAccessType: Int, Codable {
    
    case accessPrivate = 0
    case accessPublic = 1
    case accessFriendsOnly = 3
    case accessSelectedFriendsOnly = 4
    
}

struct HappeningEvent: FireStoreSaveable {
    
    let id: String
    var ownerID: String
    var accessType: EventAccessType
    var address: Address
    var imageURL: String?
    var idOfUsersWhoLiked: [String] = []
    
    enum CodingKeys: String, CodingKey {
        case id
        case accessType
        case ownerID
        case address
        case imageURL
        case idOfUsersWhoLiked
    }
        
    // MARK: init
    init(ownerID: String,
         accessType: EventAccessType,
         address: Address) {
        
        self.id = UUID.init().uuidString
        self.ownerID = ownerID
        self.accessType = accessType
        self.address = address
       
    }
    
}
