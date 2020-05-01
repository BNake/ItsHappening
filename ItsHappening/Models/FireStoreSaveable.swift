//
//  BaseModelProtocol.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/26/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import Foundation

protocol FireStoreSaveable: Codable {
    var id: String { get }
    init(dict: [String: AnyObject])
}
