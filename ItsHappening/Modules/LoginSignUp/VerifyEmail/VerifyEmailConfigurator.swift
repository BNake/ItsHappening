//
//  VerifyEmailConfigurator.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/29/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit

final class VerifyEmailConfigurator: ConfiguratorProtocol {
    
    func configure(withData: ParameterProtocol?,
                   navigationService: NavigationServiceProtocol?,
                   flow: FlowProtocol?) -> MVVMPair {
        let vc = VerifyEmailViewController()
        let router = VerifyEmailRouter(navigationService: navigationService!, flow: flow)
        let vm = VerifyEmailViewModel(router: router)
        vc.setup(viewModel: vm)
        return (vc, vm)
    }
    
}
