//
//  Event.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/20/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import Foundation

class Event: BasePojoModel {
    
    public var ownerID: String
    public var address: Address
    public var imageURL: String?
    public var idOfUsersWhoLiked: [String] = []
    
    // MARK: to init from firebase, since dictionary is what firebase returns
    required init?(dict: [String : Any]) {
                
        guard let ownerID     = dict["ownerID"] as? String else { return nil }
        guard let addressDict = dict["address"] as? [String: Any] else { return nil }
        guard let address     = Address(dict: addressDict) else { return nil }

        self.ownerID = ownerID
        self.address = address
        self.imageURL = dict["imageURL"] as? String
        self.idOfUsersWhoLiked = (dict["idOfUsersWhoLiked"] as? [String : String])?.keys.map { $0 } ?? []
        
        super.init(dict: dict)
    }
    
    // MARK: init
    init(ownerID: String,
         address: Address) {
        
        var dict = [String: Any]()
        dict["id"] = UUID.init().uuidString
        self.ownerID = ownerID
        self.address = address
        super.init(dict: dict)!
        
    }
}
