//
//  LoginOptionsRouter.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/21/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit

protocol LoginOptionsRouterProtocol: RouterProtocol {
    func showLogin(completion: Action?)
}

class LoginOptionsRouter: BaseRouter, LoginOptionsRouterProtocol {
    
    override func close<T: ViewModelProtocol>(_ viewModel: T, completion: Action? = nil) {
        navigationService.remove(viewModel: viewModel)
    }
    
    func showLogin(completion: Action? = nil) {
        FirebaseAuthService.sharedInstance.showFUILogin(navServ: navigationService) {
            completion?()
        }
    }
}
