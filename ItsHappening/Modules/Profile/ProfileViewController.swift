//
//  ProfileViewController.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/1/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ProfileViewController: BaseViewController<ProfileViewModel> {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    // MARK: ui
    
    let scrollContainer: UIScrollView = {
        let v = UIScrollView()
        return UIScrollView()
    }()
    
    let allScrollableViewsContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.clipsToBounds = true
        return imageview
    }()

    private let logoLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorManager.hBlack
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return label
    }()

    private let topLogoContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorManager.hBlack
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    // MARK: input fields
    
    private let profileImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.clipsToBounds = true
        imageview.isUserInteractionEnabled = true
        return imageview
    }()
    
    private let userNamefield: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.placeholder = "Username"
        textField.title = "Username"
        textField.tintColor = ColorManager.hBlack
        textField.textColor = ColorManager.hBlack
        textField.lineColor = ColorManager.hBlack
        textField.selectedTitleColor = ColorManager.hBlack
        textField.selectedLineColor = ColorManager.hBlack
        textField.lineHeight = 1.0 // bottom line height in points
        textField.selectedLineHeight = 2.0
        return textField
    }()
    
    private let firstNamefield: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.placeholder = "First Name"
        textField.title = "First"
        textField.tintColor = ColorManager.hBlack
        textField.textColor = ColorManager.hBlack
        textField.lineColor = ColorManager.hBlack
        textField.selectedTitleColor = ColorManager.hBlack
        textField.selectedLineColor = ColorManager.hBlack
        textField.lineHeight = 1.0 // bottom line height in points
        textField.selectedLineHeight = 2.0
        return textField
    }()
    
    private let lastNamefield: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.placeholder = "Last Name"
        textField.title = "Last"
        textField.tintColor = ColorManager.hBlack
        textField.textColor = ColorManager.hBlack
        textField.lineColor = ColorManager.hBlack
        textField.selectedTitleColor = ColorManager.hBlack
        textField.selectedLineColor = ColorManager.hBlack
        textField.lineHeight = 1.0 // bottom line height in points
        textField.selectedLineHeight = 2.0
        return textField
    }()
    
    private let phoneNumberfield: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.placeholder = "Phone Number"
        textField.title = "Phone"
        textField.tintColor = ColorManager.hBlack
        textField.textColor = ColorManager.hBlack
        textField.lineColor = ColorManager.hBlack
        textField.selectedTitleColor = ColorManager.hBlack
        textField.selectedLineColor = ColorManager.hBlack
        textField.lineHeight = 1.0 // bottom line height in points
        textField.selectedLineHeight = 2.0
        return textField
    }()
    
    private let saveButton: RoundedButton = {
        let button = RoundedButton()
        button.backgroundColor = .clear
        button.setTitleColor(ColorManager.hWhite, for: .normal)
        button.backgroundColor = ColorManager.hBlue
        button.layer.borderColor = ColorManager.label.cgColor
        return button
    }()
    
    override func setupUI() {
        forceSetupCloseButton()
        
        topLogoContainerView.add(logoImageView,
                                 logoLabel)
        
        allScrollableViewsContainer.add(topLogoContainerView,
                 titleLabel,
                 profileImageView,
                 userNamefield,
                 firstNamefield,
                 lastNamefield,
                 phoneNumberfield)
        
        scrollContainer.add(allScrollableViewsContainer)
        
        self.view.add(scrollContainer, saveButton)
        
        let size = UIScreen.main.bounds
        self.scrollContainer.frame = CGRect.init(origin: size.origin,
                                             size: CGSize(width: size.width, height: size.height - 60))
        self.scrollContainer.contentSize = CGSize(width: size.width,
                                                  height: size.height * 1.1)
        allScrollableViewsContainer.frame = CGRect.init(origin: size.origin,
                                                   size: CGSize(width: size.width, height: size.height))

        topLogoContainerView.makeLayout {
            $0.centerX.equalToSuperView()
            $0.top.equalToSuperView().offset(size.height * 0.02)
            $0.left.equalToSuperView().offset(16)
            $0.right.equalToSuperView().offset(16)
            $0.height.equalTo(size.height * 0.06)
        }

        logoImageView.makeLayout {
            $0.centerY.equalToSuperView()
            $0.centerX.equalToSuperView().offset( size.width * -0.16)
            $0.height.equalTo(30)
            $0.width.equalTo(30)
        }

        logoLabel.makeLayout {
            $0.centerY.equalToSuperView()
            $0.leading.equalTo(logoImageView.sl.trailing).offset(10)
            $0.trailing.equalToSuperView()
            $0.bottom.equalToSuperView()
            $0.top.equalToSuperView()
        }
        
        titleLabel.makeLayout {
            $0.centerX.equalToSuperView()
            $0.top.equalTo(topLogoContainerView.sl.bottom).offset(size.width * 0.02)
            $0.left.equalToSuperView().offset(10)
            $0.right.equalToSuperView().offset(10)
        }
        
        profileImageView.makeLayout {
            $0.centerX.equalToSuperView()
            $0.top.equalTo(titleLabel.sl.bottom).offset(size.height * 0.07)
            $0.height.equalTo(size.width * 0.33)
            $0.width.equalTo(size.width * 0.33)
        }
        
        userNamefield.makeLayout {
            $0.centerX.equalToSuperView()
            $0.top.equalTo(profileImageView.sl.bottom).offset(size.height * 0.02)
            $0.left.equalToSuperView().offset(size.width * 0.05)
            $0.right.equalToSuperView().offset(size.width * 0.05)
            $0.height.equalTo(size.height * 0.07)
        }
        
        firstNamefield.makeLayout {
            $0.centerX.equalToSuperView()
            $0.top.equalTo(userNamefield.sl.bottom).offset(size.height * 0.01)
            $0.left.equalToSuperView().offset(size.width * 0.05)
            $0.right.equalToSuperView().offset(size.width * 0.05)
            $0.height.equalTo(size.height * 0.07)
        }
        
        lastNamefield.makeLayout {
            $0.centerX.equalToSuperView()
            $0.top.equalTo(firstNamefield.sl.bottom).offset(size.height * 0.01)
            $0.left.equalToSuperView().offset(size.width * 0.05)
            $0.right.equalToSuperView().offset(size.width * 0.05)
            $0.height.equalTo(size.height * 0.07)
        }
        
        phoneNumberfield.makeLayout {
            $0.centerX.equalToSuperView()
            $0.top.equalTo(lastNamefield.sl.bottom).offset(size.height * 0.01)
            $0.left.equalToSuperView().offset(size.width * 0.05)
            $0.right.equalToSuperView().offset(size.width * 0.05)
            $0.height.equalTo(size.height * 0.07)
        }
        
        saveButton.makeLayout {
            $0.centerX.equalToSuperView()
            $0.bottom.equalToSuperView().offset(size.height * 0.05)
            $0.leading.equalTo(view.sl.leading).offset(16)
            $0.trailing.equalTo(view.sl.trailing).offset(16)
            $0.height.equalTo(50)
        }
    }
    
    override func setupBinding() {
        
        // MARK: apearance
        viewModel.logoImageDriver.drive(logoImageView.rx.image).disposed(by: disposeBag)
        viewModel.profileImageDriver.drive(profileImageView.rx.image).disposed(by: disposeBag)
        viewModel.logoTextDriver.drive(logoLabel.rx.text).disposed(by: disposeBag)
        viewModel.titleTextDriver.drive(titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.saveButtonTextDriver.drive(saveButton.rx.title()).disposed(by: disposeBag)
        
        //MARK: input
        userNamefield.rx.text.orEmpty.asDriver().drive(viewModel.username).disposed(by: disposeBag)
        firstNamefield.rx.text.orEmpty.asDriver().drive(viewModel.firstName).disposed(by: disposeBag)
        lastNamefield.rx.text.orEmpty.asDriver().drive(viewModel.lastName).disposed(by: disposeBag)
        phoneNumberfield.rx.text.orEmpty.asDriver().drive(viewModel.phoneNumber).disposed(by: disposeBag)
        
        //MARK: validation
        // viewModel.isAllInputValid.asDriver(onErrorJustReturn: false).drive(sa)

        // MARK: action
        closeBarButton.rx.tap.bind(to: viewModel.closeCommand).disposed(by: disposeBag)
        saveButton.rx.tap.bind(to: viewModel.saveCommand).disposed(by: disposeBag)
        profileImageView.addTapGestureRecognizer {
            self.viewModel.profileImageCommand.accept(())
            self.profileImageView.popAnimate()
        }
    }
    
}
