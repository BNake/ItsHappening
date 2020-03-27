//
//  LoginViewController.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/21/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController<LoginViewModel> {
    
    // MARK: views
    
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
    
    private let topContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let emailTextField: RoundedTextField = {
        let textField = RoundedTextField()
        textField.placeholder = "* Email"
        textField.textColor = ColorManager.hBlack
        textField.backgroundColor = ColorManager.hGray
        return textField
    }()
    
    private let passwordTextField: RoundedTextField = {
        let textField = RoundedTextField()
        textField.placeholder = "* Password"
        textField.textColor = ColorManager.hBlack
        textField.backgroundColor = ColorManager.hGray
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let loginButton: RoundedButton = {
        let button = RoundedButton()
        button.setTitleColor(ColorManager.hWhite, for: .normal)
        button.backgroundColor = ColorManager.hBlue
        return button
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.hGray
        return view
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(ColorManager.hBlue, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func setupUI() {
        
        topContainerView.add(logoImageView, titleLabel)
        view.add(topContainerView, emailTextField, passwordTextField, loginButton, separatorView, forgotPasswordButton)
        let size = UIScreen.main.bounds
        
        topContainerView.makeLayout {
            $0.centerX.equalToSuperView()
            $0.top.equalToSuperView().offset(size.height * 0.20)
            $0.left.equalToSuperView().offset(16)
            $0.right.equalToSuperView().offset(16)
            $0.height.equalTo(size.height * 0.08)
        }
        
        logoImageView.makeLayout {
            $0.centerY.equalToSuperView()
            $0.centerX.equalToSuperView().offset( size.width * -0.16)
            $0.height.equalTo(40)
            $0.width.equalTo(40)
        }
        
        titleLabel.makeLayout {
            $0.centerY.equalToSuperView()
            $0.leading.equalTo(logoImageView.sl.trailing).offset(10)
            $0.trailing.equalToSuperView()
            $0.bottom.equalToSuperView()
            $0.top.equalToSuperView()
        }
        
        emailTextField.makeLayout {
            $0.centerX.equalToSuperView()
            $0.top.equalTo(topContainerView.sl.bottom).offset(size.height * 0.05)
            $0.trailing.equalToSuperView().offset(16)
            $0.leading.equalToSuperView().offset(16)
            $0.height.equalTo(45)
        }
        
        passwordTextField.makeLayout {
            $0.centerX.equalToSuperView()
            $0.top.equalTo(emailTextField.sl.bottom).offset(size.height * 0.01)
            $0.trailing.equalToSuperView().offset(16)
            $0.leading.equalToSuperView().offset(16)
            $0.height.equalTo(45)
        }
        
        loginButton.makeLayout {
            $0.centerX.equalToSuperView()
            $0.top.equalTo(passwordTextField.sl.bottom).offset(size.height * 0.01)
            $0.trailing.equalToSuperView().offset(20)
            $0.leading.equalToSuperView().offset(20)
            $0.height.equalTo(45)
        }
        
        separatorView.makeLayout {
            $0.centerX.equalToSuperView()
            $0.top.equalTo(loginButton.sl.bottom).offset(size.height * 0.03)
            $0.trailing.equalToSuperView()
            $0.leading.equalToSuperView()
            $0.height.equalTo(1)
        }
        
        forgotPasswordButton.makeLayout {
            $0.centerX.equalToSuperView()
            $0.top.equalTo(separatorView.sl.bottom).offset(size.height * 0.002)
            $0.trailing.equalToSuperView()
            $0.leading.equalToSuperView()
            $0.height.equalTo(45)
        }
    }
    
    deinit {
        debugPrint("deinit \(self)")
    }
    
    override func setupBinding() {

        // appearance
        viewModel.logoDriver.drive(logoImageView.rx.image).disposed(by: disposeBag)
        viewModel.titleDriver.drive(titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.forgotButtonTextDriver.drive(forgotPasswordButton.rx.title()).disposed(by: disposeBag)
        viewModel.loginButtonTextDriver.drive(loginButton.rx.title()).disposed(by: disposeBag)
        
        // action
        loginButton.rx.tap.bind(to: viewModel.loginAction).disposed(by: disposeBag)
        forgotPasswordButton.rx.tap.bind(to: viewModel.forgotAction).disposed(by: disposeBag)
        closeBarButton.rx.tap.bind(to: viewModel.closeAction).disposed(by: disposeBag)
        
        // input
        emailTextField.rx.text.orEmpty.asDriver().drive(viewModel.emailInput).disposed(by: disposeBag)
        passwordTextField.rx.text.orEmpty.asDriver().drive(viewModel.passwordInput).disposed(by: disposeBag)
        
    }
    
}
