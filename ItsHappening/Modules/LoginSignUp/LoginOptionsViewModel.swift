//
//  LoginOptionsViewModel.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/21/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LoginOptionsViewModel: BaseViewModel {
    
    private(set) var tutorialPagesViewModels = [TutorialPageViewModel]()
    private let router: LoginOptionsRouterProtocol
    
    private let signupText = BehaviorRelay<String>(value: "Sign up".uppercased())
    var signupTextDriver: Driver<String> {
        return signupText.asDriver()
    }
    
    private let continueText = BehaviorRelay<String>(value: "Continue as a guest".uppercased())
    var continueTextDriver: Driver<String> {
        return continueText.asDriver()
    }
    
    let continueCommand = PublishRelay<Void>()
    let loginCommand = PublishRelay<Void>()
    
    init(router: LoginOptionsRouterProtocol) {
        self.router = router
        super.init()
        
        let pageVM1 = TutorialPageViewModel(
            mainImage: BehaviorRelay<UIImage>(value: UIImage(named: "splash")!).asObservable(),
            title: BehaviorRelay(value: "Locking for Something new?").asObservable(),
            text: BehaviorRelay(value: "Attend the newest and latest happenings in your side of town!").asObservable())
            
        
        tutorialPagesViewModels.append(contentsOf: [pageVM1])
        
        loginCommand.subscribe(onNext: { [weak self] in
            self?.showLogin()
        }).disposed(by: disposeBag)
        continueCommand.subscribe(onNext: {[weak self] in
            self?.close()
        }).disposed(by: disposeBag)
//        NotificationCenter.default.addObserver(self, selector: #selector(authLoginLogoutSuccessful), name: .authLoginLogoutSuccessful, object: nil)
    }
    
    let queue = DispatchQueue.main
    
    private func close() {
        // FIX ME
//        router.showViewModel(MainViewModel.self, completion: { [weak self] in
//            guard let self = self else { return }
//            self.router.close(self)
//        })
    }
    
    private func showLogin() {
        // router.showLogin(with: LoginParameters(authType: .signupSignin))
    }
    
    @objc func authLoginLogoutSuccessful() {
        // FIX ME
//        if AuthManager.sharedInstance.isLogin() {
//            router.showViewModel(MainViewModel.self, completion: { [weak self] in
//                guard let self = self else { return }
//                self.router.close(self)
//            })
//        }
    }
}


