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
    
    let closeCommand = PublishRelay<Void>()
    let profileImageCommand = PublishRelay<Void>()
    
    init(router: ProfileRouter) {
        self.router = router
        super.init()
        
        closeCommand.subscribe(onNext: { [weak self] in
            self?.breakFlow()
        }).disposed(by: disposeBag)
        
        profileImageCommand.subscribe(onNext: { [weak self] in
            debugPrint("clicked")
        }).disposed(by: disposeBag)
        
    }
    
    private func breakFlow() {
        router.breakFlow(self, with: nil)
    }
    
    private func next() {
        router.breakFlow(self, with: nil)
    }
    
}
