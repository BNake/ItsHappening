//
//  Protocols.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/20/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import Foundation

// MARK: - MirrorProtocol

protocol MirrorProtocol {
    static var className: String { get }
       var className: String { get }
}

extension MirrorProtocol {
    
    var className: String {
        let mirror = Mirror(reflecting: self)
        return String(describing: mirror.subjectType)
    }
    
    static var className: String {
        return String(describing: self)
    }
}

// MARK: - PreparableProtocol

protocol PreparableProtocol {
    func prepare(with: ParameterProtocol?)
}

extension PreparableProtocol {
    
    func prepare(with: ParameterProtocol?) {}
}

func addressOf<T: AnyObject>(_ object: T) -> String {
    let addr = unsafeBitCast(object, to: Int.self)
    return String(format: "%p", addr)
}

