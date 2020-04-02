//
//  ProfileViewController.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/1/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController<ProfileViewModel> {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    private let logoImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.clipsToBounds = true
        return imageview
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorManager.hBlack
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return label
    }()

    private let topLogoContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    override func setupUI() {
        forceSetupCloseButton()
        
        topLogoContainerView.add(logoImageView, titleLabel)
        view.add(topLogoContainerView)
        let size = UIScreen.main.bounds

        topLogoContainerView.makeLayout {
            $0.centerX.equalToSuperView()
            $0.top.equalToSuperView().offset(size.height * 0.12)
            $0.left.equalToSuperView().offset(16)
            $0.right.equalToSuperView().offset(16)
            $0.height.equalTo(size.height * 0.08)
        }

        logoImageView.makeLayout {
            $0.centerY.equalToSuperView()
            $0.centerX.equalToSuperView().offset( size.width * -0.16)
            $0.height.equalTo(25)
            $0.width.equalTo(25)
        }

        titleLabel.makeLayout {
            $0.centerY.equalToSuperView()
            $0.leading.equalTo(logoImageView.sl.trailing).offset(10)
            $0.trailing.equalToSuperView()
            $0.bottom.equalToSuperView()
            $0.top.equalToSuperView()
        }
    }
    
    override func setupBinding() {
        
        viewModel.logoImageDriver.drive(logoImageView.rx.image).disposed(by: disposeBag)
        viewModel.logoTextDriver.drive(titleLabel.rx.text).disposed(by: disposeBag)
        
        closeBarButton.rx.tap.bind(to: viewModel.closeCommand).disposed(by: disposeBag)
    }
}
