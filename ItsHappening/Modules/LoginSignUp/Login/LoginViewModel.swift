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
import FirebaseUI

enum LoginResult {
    case success
    case failed
}

class LoginViewModel: BaseViewModel {
    
    // MARK: router
    private let router: LoginRouter
            
    // MARK: init
    
    init(router: LoginRouter) {
        self.router = router
        super.init()
        
    }
    
}
