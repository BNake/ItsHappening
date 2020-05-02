//
//  SegmentControlContainerView.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 5/2/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit

class SegmentControlContainerView: UIView {
    
    let controlHeight: CGFloat = 38.0

    let controlView: UISegmentedControl

    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.opaqueSeparator
        return view
    }()
    
    init(segmentControl: UISegmentedControl) {
        self.controlView = segmentControl
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.add(controlView, separator)
        
        controlView.makeLayout { (make) in
            make.top.equalToSuperView().offset(16)
            make.trailing.equalToSuperView().offset(16)
            make.leading.equalToSuperView().offset(16)
            make.height.equalTo(controlHeight)
        }

        separator.makeLayout { (make) in
            make.top.equalTo(controlView.sl.bottom).offset(16)
            make.trailing.equalToSuperView()
            make.leading.equalToSuperView()
            make.height.equalTo(1)
            make.bottom.equalToSuperView()
        }
    }
    
}
