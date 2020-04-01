//
//  DisplayError.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/20/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

enum ErrorCode {
    case Not_Found
    case Parse_Error
    case DENIED
    case unknown
}

struct DisplayError: Error {

    let title: String?
    let message: String
    let code: ErrorCode

    init(title: String? = nil, message: String) {
        self.title = title
        self.message = message
        self.code = .unknown
    }
    
    init(code: ErrorCode, message: String) {
        self.code = code
        self.message = message
        self.title = nil
    }
    
}

