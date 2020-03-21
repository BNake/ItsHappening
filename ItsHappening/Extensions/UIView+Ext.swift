//
//  UIView+Ext.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/20/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit

extension UIView {

    public func add(_ subviews: UIView...) {
        subviews.forEach(addSubview)
    }

}

extension CGRect {
    static var notZero: CGRect {
        return CGRect(x: 0, y: 0, width: 0, height: 0.0001)
    }
}

extension UIAlertAction {
    convenience init(title: String?, style: DialogStyle, action: Action? = nil) {
        switch style {
        case .destructive:
            self.init(title: title, style: .destructive, handler: {_ in action?()})
        case .cancel:
            self.init(title: title, style: .cancel, handler: {_ in action?()})
        default:
            self.init(title: title, style: .default, handler: {_ in action?()})
        }
    }
}

public extension UIView {
    
    var sl: OMSimpleLayout {
        return OMSimpleLayout(view: self)
    }
    
    func makeLayout(_ make: ((OMSimpleLayout) -> Void)) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constrainsBox = OMConstraintsBox()
        let layout = OMSimpleLayout(view: self, constaintsBox: constrainsBox)
        make(layout)
        constrainsBox.constraints.forEach { $0.isActive = true }
    }
    
}



