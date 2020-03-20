//
//  BaseModel.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/20/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import Foundation

public protocol PojoModelProtocol {
    init?(dict: [String: Any])
}

class BasePojoModel: NSObject, PojoModelProtocol {
    public let id: String
    
    required init?(dict: [String : Any]) {
        guard let id = dict["id"] as? String else { return nil }
        self.id = id
    }
}
