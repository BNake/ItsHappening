//
//  Coordinate.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/20/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import Foundation

class Coordinate: BasePojoModel {
    let latitude: Double
    let longitude: Double
    
    // MARK: to init from firebase, since dictionary is what firebase returns
    required init?(dict: [String : Any]) {
                
        guard let latitude  = dict["latitude"] as? Double else { return nil }
        guard let longitude = dict["longitude"] as? Double else { return nil }

        self.latitude = latitude
        self.longitude = longitude
        
        super.init(dict: dict)
    }
    
    // MARK: init
    init(latitude: Double, longitude: Double) {
        
        var dict = [String: Any]()
        dict["id"] = UUID.init().uuidString
        self.latitude = latitude
        self.longitude = longitude
        super.init(dict: dict)!
    }
}
