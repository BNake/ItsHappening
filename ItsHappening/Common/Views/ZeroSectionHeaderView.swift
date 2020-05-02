//
//  ZeroSectionHeaderView.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 5/2/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit

class ZeroSectionHeaderView: SettingsSectionView {

    override func setupUI() {
        backgroundColor = .clear
        let clearView = UIView()
        add(clearView)
        clearView.makeLayout {
            $0.edges.equalToSuperView()
            $0.height.equalTo(1)
        }
    }

}
