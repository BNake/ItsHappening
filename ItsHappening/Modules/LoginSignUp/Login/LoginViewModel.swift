//
//  LoginViewModel.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/21/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewModel: BaseViewModel {
    
    // MARK: router
    
    private let router: LoginRouter
    
    // MARK: appearance
    
    private let title = BehaviorRelay<String>(value: "It'sHappening")
    public var titleDriver: Driver<String> {
        return title.asDriver()
    }
    
    private let logoImage = BehaviorRelay<UIImage>(value: UIImage(named: "logo")!)
    public var logoDriver: Driver<UIImage> {
        return logoImage.asDriver()
    }
    
    private let emailPlaceHolder = BehaviorRelay<String>(value: "Email")
    public var emailPlaceHolderDriver: Driver<String> {
        emailPlaceHolder.asDriver()
    }
    
    private let passwordPlaceHolder = BehaviorRelay<String>(value: "Password")
    public var passwordPlaceHolderDriver: Driver<String> {
        passwordPlaceHolder.asDriver()
    }
    
    private let loginButtonText = BehaviorRelay<String>(value: "Log In")
    public var loginButtonTextDriver: Driver<String> {
        loginButtonText.asDriver()
    }
    
    private let forgotButtonText = BehaviorRelay<String>(value: "Forgot your password?")
    public var forgotButtonTextDriver: Driver<String> {
        forgotButtonText.asDriver()
    }
    
    // MARK: Action
    
    let loginAction = PublishRelay<Void>()
    let forgotAction = PublishRelay<Void>()
    let closeAction = PublishRelay<Void>()
    
    // MARK: input
    
    let emailInput = BehaviorRelay<String>(value: "")
    let passwordInput = BehaviorRelay<String>(value: "")
    
    // MARK: init
    
    init(router: LoginRouter) {
        self.router = router
        super.init()
        
        loginAction.subscribe(onNext: { [weak self] in
            self?.login()
        }).disposed(by: disposeBag)
        
        forgotAction.subscribe(onNext: { [weak self] in
            self?.forgotPassword()
        }).disposed(by: disposeBag)
        
        closeAction.subscribe(onNext: { [weak self] in
            self?.close()
        }).disposed(by: disposeBag)
        
    }
    
    private func login() {
        print("login tapped \n\(emailInput.value) \n\(passwordInput.value)")
    }
    
    private func forgotPassword() {
        print("forgot tapped")
    }
    
    func close() {
        router.closePresented()
    }
    
}
