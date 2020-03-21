//
//  DisplayError.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/20/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

struct DisplayError: Error {

    let title: String?
    let message: String

    init(title: String? = nil, message: String) {
        self.title = title
        self.message = message
    }
    
}

