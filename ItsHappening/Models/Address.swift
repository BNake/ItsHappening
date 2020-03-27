//
//  Address.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/20/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import Foundation

struct Address: Codable {
    
    let streetAddress: String
    let city: String
    let state: String
    let zipCode: String
    let coordinate: Coordinate
    
}
