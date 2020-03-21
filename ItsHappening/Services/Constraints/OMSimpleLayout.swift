//
//  OMSimpleLayout.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/20/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit

public class OMSimpleLayout {
    
    fileprivate let view: UIView
    fileprivate var safeAreaGuide: UILayoutGuide?
    fileprivate var _attributes: [NSLayoutConstraint.Attribute] = []
    
    fileprivate let constaintsBox: OMConstraintsBox
    
    internal var attributes: [NSLayoutConstraint.Attribute] {
        return _attributes
    }
    
    public var left: OMConstraintMaker {
        _attributes = [.left]
        return OMConstraintMaker(attributes: _attributes, view: view, constraintsBox: constaintsBox, safeAreaGuide: safeAreaGuide)
    }
    
    public var right: OMConstraintMaker {
        _attributes = [.right]
        return OMConstraintMaker(attributes: _attributes, view: view, constraintsBox: constaintsBox, safeAreaGuide: safeAreaGuide)
    }
    
    public var top: OMConstraintMaker {
        _attributes = [.top]
        return OMConstraintMaker(attributes: _attributes, view: view, constraintsBox: constaintsBox, safeAreaGuide: safeAreaGuide)
    }
    
    public var bottom: OMConstraintMaker {
        _attributes = [.bottom]
        return OMConstraintMaker(attributes: _attributes, view: view, constraintsBox: constaintsBox, safeAreaGuide: safeAreaGuide)
    }
    
    public var leading: OMConstraintMaker {
        _attributes = [.leading]
        return OMConstraintMaker(attributes: _attributes, view: view, constraintsBox: constaintsBox, safeAreaGuide: safeAreaGuide)
    }
    
    public var trailing: OMConstraintMaker {
        _attributes = [.trailing]
        return OMConstraintMaker(attributes: _attributes, view: view, constraintsBox: constaintsBox, safeAreaGuide: safeAreaGuide)
    }
    
    public var width: OMDemensionConstraintMaker {
        _attributes = [.width]
        return OMDemensionConstraintMaker(attributes: _attributes, view: view, constraintsBox: constaintsBox, safeAreaGuide: safeAreaGuide)
    }
    
    public var height: OMDemensionConstraintMaker {
        _attributes = [.height]
        return OMDemensionConstraintMaker(attributes: _attributes, view: view, constraintsBox: constaintsBox, safeAreaGuide: safeAreaGuide)
    }
    
    public var centerX: OMConstraintMaker {
        _attributes = [.centerX]
        return OMConstraintMaker(attributes: _attributes, view: view, constraintsBox: constaintsBox, safeAreaGuide: safeAreaGuide)
    }
    
    public var centerY: OMConstraintMaker {
        _attributes = [.centerY]
        return OMConstraintMaker(attributes: _attributes, view: view, constraintsBox: constaintsBox, safeAreaGuide: safeAreaGuide)
    }

    public var center: OMConstraintMaker {
        _attributes = [.centerX, .centerY]
        return OMConstraintMaker(attributes: _attributes, view: view, constraintsBox: constaintsBox, safeAreaGuide: safeAreaGuide)
    }
    
    public var size: OMSizeConstraintMaker {
        _attributes = [.width, .height]
        return OMSizeConstraintMaker(attributes: _attributes, view: view, constraintsBox: constaintsBox, safeAreaGuide: safeAreaGuide)
    }
    
    public var edges: OMConstraintMaker {
        _attributes = [.leading, .top, .trailing, .bottom]
        return OMConstraintMaker(attributes: _attributes, view: view, constraintsBox: constaintsBox, safeAreaGuide: safeAreaGuide)
    }
    
    init(view: UIView, constaintsBox: OMConstraintsBox = OMConstraintsBox(), safeAreaGuide: UILayoutGuide? = nil) {
        self.view = view
        self.constaintsBox = constaintsBox
        self.safeAreaGuide = safeAreaGuide
    }
    
}

