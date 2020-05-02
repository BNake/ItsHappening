//
//  SettingsSectionView.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 5/2/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SettingsSectionView: BaseSectionView<SectionViewModel>, InitiableProtocol {
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = ColorManager.secondaryLabel
        return label
    }()
    
    required override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        add(label)
        backgroundColor = ColorManager.systemGroupedBackground
        label.makeLayout {
            $0.bottom.equalTo(self.sl.bottom).offset(7)
            $0.left.equalTo(self.sl.left).offset(17)
            $0.top.equalTo(self.sl.top).offset(38)
        }
    }
    
    override func setupBinding() {
       viewModel?.name?.drive(label.rx.text).disposed(by: disposeBag)
    }
}

