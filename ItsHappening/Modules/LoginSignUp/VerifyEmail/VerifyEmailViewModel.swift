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
    
    private var timer: Disposable?
    private let timeout = 500
    private let verificationListener = PublishRelay<String>()
    var verificationListenerDriver: Driver<String> {
        return verificationListener.asDriver(onErrorJustReturn: "")
    }
    
    let didntGetEmailCommand = PublishRelay<Void>()
    let closeAction = PublishRelay<Void>()
    
    init(router: VerifyEmailRouter) {
        self.router = router
        super.init()
        sendEmailVerification()
        
        // bind on click
        
        didntGetEmailCommand.subscribe(onNext: { [weak self] in
            self?.sendEmailVerification()
        }).disposed(by: disposeBag)
        
        closeAction.subscribe(onNext: { [weak self] in
            self?.breakFlow()
        }).disposed(by: disposeBag)
        
        // Every second check if user verified email
        
        timer = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
                    // map from int to String
                    .map { [weak self] value -> String in
                        return self?.getTimeRemaining(value: value) ?? ""
                    }
                    .subscribe({ [weak self] (value) in
                        guard let message = value.element else { return }
                        
                        if FirebaseAuthService.sharedInstance.isEmailVerified() {
                            
                            self?.stopTimer()
                            self?.next()
                            return
                        }
                        self?.reloadUserData()
                        self?.verificationListener.accept(message)
                    })
        

    }
    
    private func breakFlow() {
        router.breakFlow(self, with: nil)
    }
    
    private func next() {
        router.next(self, with: nil)
    }
    
    private func stopTimer() {
        timer?.dispose()
    }
    
    private func sendEmailVerification() {
        
        FirebaseAuthService.sharedInstance.sendVerificationCode(success: {
            
        }) { (error) in
            debugPrint(error)
        }
    }
    
    private func reloadUserData() {
        
        // reload user data
        FirebaseAuthService.sharedInstance.reloadUserData(success: {
            
        }) { (error) in
            debugPrint(error)
        }
    }
    
    private func getTimeRemaining(value: Int) -> String {
        
        guard value <= timeout else {
            self.timer?.dispose()
            router.breakFlow(self, with: nil)
            return ""
        }
        
        return "Time remaining \(timeout - value)"
    }
    
}
