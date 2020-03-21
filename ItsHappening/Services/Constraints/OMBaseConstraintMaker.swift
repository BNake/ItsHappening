//
//  OMBaseConstraintMaker.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/20/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit

public class OMBaseConstraintMaker {

    internal let view: UIView
    internal var safeAreaGuide: UILayoutGuide?
    internal let attributes: [NSLayoutConstraint.Attribute]
    internal let constraintsBox: OMConstraintsBox

    internal var item: Any {
        if let safeArea = safeAreaGuide {
            return safeArea
        }
        return view
    }

    init(attributes: [NSLayoutConstraint.Attribute], view: UIView, constraintsBox: OMConstraintsBox, safeAreaGuide: UILayoutGuide? = nil) {
        self.view = view
        self.attributes = attributes
        self.constraintsBox = constraintsBox
        self.safeAreaGuide = safeAreaGuide
    }

    internal func makeConstraints(_ relatedBy: NSLayoutConstraint.Relation, to constraintMaker: OMBaseConstraintMaker? = nil, constant: CGFloat = 0) -> OMOffsetConstraintChanger {
        var constraints: [NSLayoutConstraint] = []
        for (index, attribute) in attributes.enumerated() {
            let constraint = NSLayoutConstraint.init(item: item,
                                                     attribute: attribute,
                                                     relatedBy: relatedBy,
                                                     toItem: constraintMaker?.item,
                                                     attribute: constraintMaker?.attributes[index] ?? .notAnAttribute,
                                                     multiplier: 1.0,
                                                     constant: constant)
            constraintsBox.constraints.append(constraint)
            constraints.append(constraint)
        }

        return OMOffsetConstraintChanger(constraints: constraints, constraintsBox: constraintsBox)
    }

}

