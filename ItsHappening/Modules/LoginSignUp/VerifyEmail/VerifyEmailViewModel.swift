//
//  VerifyEmailViewModel.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/29/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class VerifyEmailViewModel: BaseViewModel {
    
    let router: VerifyEmailRouter
    
    private let titleText = BehaviorRelay<String>(value: "Email was sent!")
    var titleDriver: Driver<String> {
        return titleText.asDriver()
    }
    
    private let didNotGetEmailText = BehaviorRelay<String>(value: "Didn't get email?")
    var didNtgetEmailDriver: Driver<String> {
        didNotGetEmailText.asDriver()
    }
    
    let didntGetEmailCommand = PublishRelay<Void>()
    let closeAction = PublishRelay<Void>()
    
    init(router: VerifyEmailRouter) {
        self.router = router
        super.init()
        sendEmailVerification()
        
        didntGetEmailCommand.subscribe(onNext: { [weak self] in
            self?.sendEmailVerification()
        }).disposed(by: disposeBag)
        
        closeAction.subscribe(onNext: { [weak self] in
            self?.breakFlow()
        }).disposed(by: disposeBag)
    }
    
    private func sendEmailVerification() {
        FirebaseAuthService.sharedInstance.sendVerificationCode(success: {
            
        }) { (error) in
            debugPrint(error)
        }
    }
    
    private func breakFlow() {
        router.breakFlow(self, with: nil)
    }
}
