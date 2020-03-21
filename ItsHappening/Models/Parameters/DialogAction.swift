//
//  DialogAction.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/20/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import Foundation

enum DialogStyle {
    case `default`, cancel, destructive
}

struct DialogAction {
    var title: String
    var style: DialogStyle
    var action: Action?
}


