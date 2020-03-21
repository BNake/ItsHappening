//
//  OMSizeConstraintMaker.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/20/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit

public class OMDemensionConstraintMaker: OMConstraintMaker {
    
    @discardableResult
    public func equalTo(_ value: CGFloat) -> OMBaseConstraintChanger {
        return makeConstraints(.equal, constant: value)
    }
    
    @discardableResult
    public func greateThan(_ value: CGFloat) -> OMBaseConstraintChanger {
        return makeConstraints(.greaterThanOrEqual, constant: value)
    }
    
    @discardableResult
    public func lessThan(_ value: CGFloat) -> OMBaseConstraintChanger {
        return makeConstraints(.lessThanOrEqual, constant: value)
    }
    
}

public class OMSizeConstraintMaker: OMConstraintMaker {

    private func makeSizeConstraints(size: CGSize, _ relatedBy: NSLayoutConstraint.Relation) -> OMBaseConstraintChanger {
        var constraints: [NSLayoutConstraint] = []
        let widthConstraint = NSLayoutConstraint(item: item, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: size.width)
        let heightConstraint = NSLayoutConstraint(item: item, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: size.height)

        constraints.append(widthConstraint)
        constraints.append(heightConstraint)
        constraintsBox.constraints.append(contentsOf: constraints)

        return OMBaseConstraintChanger(constraints: constraints, constraintsBox: constraintsBox)
    }

    @discardableResult
    public func equalTo(_ size: CGSize) -> OMBaseConstraintChanger {
        return makeSizeConstraints(size: size, .equal)
    }

    @discardableResult
    public func greateThan(_ size: CGSize) -> OMBaseConstraintChanger {
        return makeSizeConstraints(size: size, .greaterThanOrEqual)
    }

    @discardableResult
    public func lessThan(_ size: CGSize) -> OMBaseConstraintChanger {
        return makeSizeConstraints(size: size, .lessThanOrEqual)
    }

}

