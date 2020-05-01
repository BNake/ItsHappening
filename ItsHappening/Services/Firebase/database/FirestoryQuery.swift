//
//  FirestoryQuery.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/28/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

enum QueryOperator {
    case isEqualTo
    case isLessThan
    case isLessThanOrEqualTo
    case isGreaterThan
    case isGreaterThanOrEqualTo
}

struct FirestoryQuery {
    let propertyName: String
    let value: String
    let queryOperator: QueryOperator
    let limit: Int
}
