//
//  SimpleTextCell.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/26/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SimpleTextCell: BaseTableViewCell<SimpleTextViewModel> {

    private let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        label.text = "PH: Title"
        return label
    }()

    override func setupUI() {
        self.backgroundColor = .clear
        
        containerView.add(title)
        containerView.makeLayout { (make) in
            make.height.equalTo(50)
        }

        title.makeLayout { (make) in
            make.top.equalToSuperView().offset(16)
            make.leading.equalToSuperView().offset(16)
            make.trailing.equalToSuperView().offset(16)
        }
    }

    override func setupBinding() {
        viewModel.title.bind(to: title.rx.text).disposed(by: disposeBag)
    }

}

