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
    
    let closeCommand = PublishRelay<Void>()
    
    init(router: ProfileRouter) {
        self.router = router
        super.init()
        
        closeCommand.subscribe(onNext: { [weak self] in
            self?.breakFlow()
        }).disposed(by: disposeBag)
    }
    
    private func breakFlow() {
        router.breakFlow(self, with: nil)
    }
    
    private func next() {
        router.breakFlow(self, with: nil)
    }
    
}
