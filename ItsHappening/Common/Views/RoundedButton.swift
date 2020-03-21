//
//  RoundedButton.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/21/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    convenience init() {
        self.init(type: .system)
        self.contentEdgeInsets = UIEdgeInsets(top: 3, left: 15, bottom: 3, right: 15)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 8
    }
}

