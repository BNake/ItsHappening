//
//  OMConstraintMaker.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/20/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import Foundation

public class OMConstraintMaker: OMBaseConstraintMaker {
    
    // MARK: - to item
    
    @discardableResult
    public func equalTo(_ item: OMBaseConstraintMaker) -> OMOffsetConstraintChanger {
        return makeConstraints(.equal, to: item)
    }
    
    @discardableResult
    public func greateThan(_ item: OMBaseConstraintMaker) -> OMOffsetConstraintChanger {
        return makeConstraints(.greaterThanOrEqual, to: item)
    }
    
    @discardableResult
    public func lessThan(_ item: OMBaseConstraintMaker) -> OMOffsetConstraintChanger {
        return makeConstraints(.lessThanOrEqual, to: item)
    }
    
    // MARK: - to superView
    
    @discardableResult
    public func equalToSuperView() -> OMOffsetConstraintChanger {
        let superViewItem = OMConstraintMaker(attributes: attributes, view: view.superview!, constraintsBox: OMConstraintsBox())
        return makeConstraints(.equal, to: superViewItem)
    }

    @available(iOS 11.0, *)
    @discardableResult
    public func equalToSafeArea() -> OMOffsetConstraintChanger {
        let safeAreaGuide = view.superview!.safeAreaLayoutGuide
        let superViewItem = OMConstraintMaker(attributes: attributes, view: view.superview!, constraintsBox: OMConstraintsBox(), safeAreaGuide: safeAreaGuide)
        return makeConstraints(.equal, to: superViewItem)
    }
    
    @discardableResult
    public func greateThanSuperView() -> OMOffsetConstraintChanger {
        let superViewItem = OMConstraintMaker(attributes: attributes, view: view.superview!, constraintsBox: OMConstraintsBox())
        return makeConstraints(.greaterThanOrEqual, to: superViewItem)
    }
    
    @discardableResult
    public func lessThanSuperView() -> OMOffsetConstraintChanger {
        let superViewItem = OMConstraintMaker(attributes: attributes, view: view.superview!, constraintsBox: OMConstraintsBox())
        return makeConstraints(.lessThanOrEqual, to: superViewItem)
    }
    
}

