//
//  LoginConfigurator.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/21/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit
import FirebaseUI

final class LoginConfigurator: ConfiguratorProtocol {
    
    func configure(withData data: ParameterProtocol?, navigationService: NavigationServiceProtocol?, flow: FlowProtocol?) -> MVVMPair {
        
        // Firebase Auth UI
        let authUI = FUIAuth.defaultAuthUI()
        authUI?.providers = [ FUIEmailAuth(), FUIGoogleAuth(), FUIFacebookAuth() ]
        
        let loginRouter = LoginRouter(navigationService: navigationService!, flow: flow)
        let viewModel = LoginViewModel(router: loginRouter)
        
        let viewController = LoginViewController.init(authUI: authUI!)
        authUI?.delegate = FirebaseAuthService.sharedInstance
        viewController.setup(viewModel: viewModel)
        
        return (viewController, viewModel)
    }
    
    func configure(withData: ParameterProtocol?, navigationService: NavigationServiceProtocol?) -> MVVMPair {
        return configure(withData: withData, navigationService: navigationService, flow: nil)
    }
    
}

