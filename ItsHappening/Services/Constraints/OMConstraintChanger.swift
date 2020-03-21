//
//  OMConstraintChanger.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/20/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit

public class OMBaseConstraintChanger {
    
    fileprivate var currentConstraints: [NSLayoutConstraint]
    fileprivate let constraintsBox: OMConstraintsBox
    
    init(constraints: [NSLayoutConstraint], constraintsBox: OMConstraintsBox) {
        self.currentConstraints = constraints
        self.constraintsBox = constraintsBox
    }
    
    @discardableResult
    public func priority(_ value: Float) -> OMBaseConstraintChanger {
        let priority = UILayoutPriority(value)
        currentConstraints.forEach { $0.priority = priority }
        return self
    }
    
    @discardableResult
    public func multiplier(_ value: CGFloat) -> OMBaseConstraintChanger {
        var newConstraints: [NSLayoutConstraint] = []
        
        currentConstraints.forEach {
            let newConstraint = NSLayoutConstraint(item: $0.firstItem!,
                                                   attribute: $0.firstAttribute,
                                                   relatedBy: $0.relation,
                                                   toItem: $0.secondItem,
                                                   attribute: $0.secondAttribute,
                                                   multiplier: value,
                                                   constant: $0.constant)
            newConstraints.append(newConstraint)
            if let oldConstraintIndex = constraintsBox.constraints.firstIndex(of: $0) {
                constraintsBox.constraints.remove(at: oldConstraintIndex)
            }
        }
        
        currentConstraints = newConstraints
        constraintsBox.constraints.append(contentsOf: newConstraints)
        
        return self
    }

    public func getConstraint() -> NSLayoutConstraint {
        return currentConstraints.first!
    }

    public func getConstraints() -> [NSLayoutConstraint] {
        return currentConstraints
    }

}

public class OMOffsetConstraintChanger: OMBaseConstraintChanger {

    @discardableResult
    public func offset(_ value: CGFloat) -> OMOffsetConstraintChanger {
        currentConstraints.forEach {
            let constant = needToInvertConstant(for: $0) ? -value : value
            $0.constant = constant
        }
        return self
    }

    private func needToInvertConstant(for constraint: NSLayoutConstraint) -> Bool {
        switch constraint.relation  {
        case .equal where [.right, .bottom, .trailing].contains(constraint.firstAttribute):
            return true
        case .equal:
            return false
        case .lessThanOrEqual where [.right, .bottom, .trailing].contains(constraint.firstAttribute):
            return true
        case .lessThanOrEqual:
            return false
        case .greaterThanOrEqual where [.right, .bottom, .trailing].contains(constraint.firstAttribute):
            return false
        case .greaterThanOrEqual:
            return true
        @unknown default:
            assertionFailure()
            return false
        }
    }
}

