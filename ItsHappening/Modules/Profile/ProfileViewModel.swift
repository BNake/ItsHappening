//
//  ProfileViewModel.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/1/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewModel: BaseViewModel {
    
    let router: ProfileRouter
    
    // MARK: apearance
    
    private let logoText = BehaviorRelay<String>(value: "Social App")
    var logoTextDriver: Driver<String> {
        return logoText.asDriver()
    }
    
    private let logoImage = BehaviorRelay<UIImage>(value: UIImage(named: "logo")!)
    var logoImageDriver: Driver<UIImage> {
        return logoImage.asDriver()
    }
    
    private let titleText = BehaviorRelay<String>(value: "Create an Account")
    var titleTextDriver: Driver<String> {
        return titleText.asDriver()
    }
    
    private let profileImage = BehaviorRelay<UIImage>(value: UIImage(named: "add_profile_image")!)
    var profileImageDriver: Driver<UIImage> {
        return profileImage.asDriver()
    }
    
    private let saveButtonText = BehaviorRelay<String>(value: "Save")
    var saveButtonTextDriver: Driver<String> {
        return saveButtonText.asDriver()
    }
    
    // MARK: input
    
    let username = BehaviorRelay<String>(value: "")
    let firstName = BehaviorRelay<String>(value: "")
    let lastName = BehaviorRelay<String>(value: "")
    let phoneNumber = BehaviorRelay<String>(value: "")
    
    // MARK: validation
    var isAllInputValid: Observable<Bool>
    
    // MARK: Action
    
    let closeCommand = PublishRelay<Void>()
    let profileImageCommand = PublishRelay<Void>()
    let saveCommand = PublishRelay<Void>()
    
    init(router: ProfileRouter) {
        self.router = router
        
        // MARK: validation
        isAllInputValid = Observable.combineLatest(username.asObservable(),
                                           firstName.asObservable(),
                                           lastName.asObservable(),
                                           phoneNumber.asObservable()) {
                                                                      username ,
                                                                      firstName,
                                                                      lastName,
                                                                      phoneNumber in
                                            
                                            let v = username.count > 5 &&
                                            firstName.count > 0 &&
                                            lastName.count > 0 &&
                                            phoneNumber.count > 10
                                            v ? debugPrint("valid") : debugPrint("not valid")// self.saveButtonText.accept("Valid") : self.saveButtonText.accept("NOT Valid")
                                            return v
        }
        super.init()
        
        // MARK: action
        closeCommand.subscribe(onNext: { [weak self] in
            self?.breakFlow()
        }).disposed(by: disposeBag)
        
        profileImageCommand.subscribe(onNext: { _ in
            debugPrint("profile image clicked")
        }).disposed(by: disposeBag)
        
        saveCommand.subscribe(onNext: { [weak self] in
            self?.saveUserProfile()
        }).disposed(by: disposeBag)
        
    }
    
    private func breakFlow() {
        router.breakFlow(self, with: nil)
    }
    
    private func next() {
        router.breakFlow(self, with: nil)
    }
    
    private func saveUserProfile() {
        debugPrint("\(username.value)")
        debugPrint("\(firstName.value)")
        debugPrint("\(lastName.value)")
        debugPrint("\(phoneNumber.value)")
    }
    
}
