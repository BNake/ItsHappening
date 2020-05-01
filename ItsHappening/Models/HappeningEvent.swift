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
    
    init(dict: [String: AnyObject]) {
        self.id = dict["id"] as? String ?? ""
        self.ownerID = dict["ownerID"] as? String ?? ""
        self.accessType = dict["accessType"] as? EventAccessType ?? .accessPrivate
        
        let streetAddress = dict["streetAddress"] as? String ?? ""
        let city = dict["city"] as? String ?? ""
        let state = dict["state"] as? String ?? ""
        let zipCode = dict["zipCode"] as? String ?? ""
        let lat = dict["latitude"] as? Double ?? 0.0
        let long = dict["streetAddress"] as? Double ?? 0.0
        let coordinate = Coordinate(latitude: lat, longitude: long)
        
        let address = Address(streetAddress: streetAddress,
                              city: city,
                              state: state,
                              zipCode: zipCode,
                              coordinate: coordinate)
        self.address = address
        self.imageURL = dict["imageURL"] as? String
        
    }
    
}
