//
//  Address.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/20/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import Foundation

class Address: BasePojoModel {
    
    let streetAddress: String
    let city: String
    let state: String
    let zipCode: String
    let coordinate: Coordinate
    
    // MARK: to init from firebase, since dictionary is what firebase returns
    required init?(dict: [String : Any]) {
                
        guard let streetAddress = dict["streetAddress"] as? String else { return nil }
        guard let city          = dict["city"] as? String else { return nil }
        guard let state         = dict["state"] as? String else { return nil }
        guard let zipCode       = dict["zipCode"] as? String else { return nil }
        guard let coordicateDict       = dict["coordinate"] as? [String: Any] else { return nil }
        guard let coordinate = Coordinate(dict: coordicateDict) else { return nil }

        self.streetAddress = streetAddress
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.coordinate = coordinate
        
        super.init(dict: dict)
    }
    
    // MARK: init
    init(streetAddress: String,
         city: String,
         state: String,
         zipCode: String,
         coordinate: Coordinate) {
        
        var dict = [String: Any]()
        dict["id"] = UUID.init().uuidString
        
        self.streetAddress = streetAddress
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.coordinate = coordinate

        super.init(dict: dict)!
    }
    
}
