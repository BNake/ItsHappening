//
//  ProfileConfigurator.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/1/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit

final class ProfileConfigurator: ConfiguratorProtocol {
    
    func configure(withData: ParameterProtocol?, navigationService: NavigationServiceProtocol?, flow: FlowProtocol?) -> MVVMPair {
        let vc = ProfileViewController()
        let router = ProfileRouter(navigationService: navigationService!, flow: flow)
        let vm = ProfileViewModel(router: router)
        vc.setup(viewModel: vm)
        return (vc, vm)
    }
    
    func configure(withData: ParameterProtocol?, navigationService: NavigationServiceProtocol?) -> MVVMPair {
        return configure(withData: withData, navigationService: navigationService, flow: nil)
    }
}



