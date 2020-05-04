//
//  ContactCell.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/27/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class ContactCell: BaseTableViewCell<ContactCellViewModel> {

    private let profileImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleToFill
        imageview.clipsToBounds = true
        imageview.isUserInteractionEnabled = true
        return imageview
    }()
    
    private let textContainer: UIView = {
        let v = UIView()
        return v
    }()
    
    private let usernameLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        label.text = "PH: Title"
        return label
    }()
    
    private let nameLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.textColor = .black
        label.numberOfLines = 0
        label.text = "PH: Title"
        return label
    }()
    
    private let actionButton: RoundedButton = {
        let button = RoundedButton()
        button.backgroundColor = .clear
        button.setTitleColor(ColorManager.hWhite, for: .normal)
        button.backgroundColor = ColorManager.hBlue
        button.layer.borderColor = ColorManager.label.cgColor
        return button
    }()

    override func setupUI() {
        self.backgroundColor = .clear
        
        textContainer.add(usernameLable, nameLable)
        containerView.add(profileImageView, textContainer, actionButton)

        let size = UIScreen.main.bounds
        
        containerView.makeLayout {
            $0.height.equalTo(size.height * 0.1)
        }
        
        profileImageView.makeLayout {
            $0.leading.equalToSuperView().offset(size.width * 0.03)
            $0.centerY.equalToSuperView()
            let length = size.height * 0.08
            $0.height.equalTo(length)
            $0.width.equalTo(length)
            self.profileImageView.layer.cornerRadius = length / 2
        }
        
        textContainer.makeLayout {
            $0.centerY.equalTo(profileImageView.sl.centerY)
            $0.top.equalToSuperView().offset(size.height * 0.02)
            $0.leading.equalTo(profileImageView.sl.trailing).offset(size.height * 0.01)
            $0.trailing.equalTo(actionButton.sl.leading).offset(size.height * 0.01)
            $0.bottom.equalToSuperView().offset(size.height * 0.01)
        }
        
        usernameLable.makeLayout {
            $0.top.equalToSuperView()
            $0.leading.equalToSuperView()
            $0.trailing.equalToSuperView()
        }
        
        nameLable.makeLayout {
            $0.top.equalTo(usernameLable.sl.bottom).offset(size.height * 0.005)
            $0.leading.equalToSuperView()
            $0.trailing.equalToSuperView()
        }
        
        actionButton.makeLayout {
            $0.centerY.equalToSuperView()
            $0.trailing.equalToSuperView().offset(size.width * 0.05)
            $0.height.equalTo(size.height * 0.1 * 0.33)
            $0.width.equalTo(size.width * 0.25)
        }
        
    }

    override func setupBinding() {
        
        //
        // MARK: apearance
        //
        viewModel.usernameDriver.drive(usernameLable.rx.text).disposed(by: disposeBag)
        viewModel.nameDriver.drive(nameLable.rx.text).disposed(by: disposeBag)
        viewModel.actionButtonTextDriver.drive(actionButton.rx.title()).disposed(by: disposeBag)
        
        viewModel.profileImageUrlDriver
            .drive(onNext: { [weak self] (url) in
                let placeHolder = UIImage.init(named: "add_profile_image")
                guard let url = url else {
                    self?.profileImageView.image = placeHolder
                    return
                }

                self?.profileImageView.kf.setImage(
                    with: url,
                    placeholder: placeHolder,
                    options: [
                        .transition(.fade(0.6)),
                        .cacheOriginalImage
                ])
            })
            .disposed(by: disposeBag)
        
        viewModel.actionButtonStateDriver.drive(onNext: { [weak self] (actionState) in
            
            self?.actionButton.isHidden = actionState.model.isHidden
            self?.actionButton.setTitle(actionState.model.title, for: .normal)
            self?.actionButton.backgroundColor = actionState.model.backgroundColor
            }).disposed(by: disposeBag)
        
        //
        // MARK: action
        //
        actionButton.rx.tap.bind(to: viewModel.actionButtonCommand).disposed(by: disposeBag)

    }

}

