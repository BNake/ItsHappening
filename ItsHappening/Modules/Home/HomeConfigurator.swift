//
//  HomeConfigurator.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/4/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit

final class HomeConfigurator: ConfiguratorProtocol {
    
    func configure(withData: ParameterProtocol?, navigationService: NavigationServiceProtocol?, flow: FlowProtocol?) -> MVVMPair {
        let vc = HomeViewController()
        let router = HomeRouter(navigationService: navigationService!, flow: flow)
        let vm = HomeViewModel(router: router)
        vc.setup(viewModel: vm)
        return (vc, vm)
    }
    
    func configure(withData: ParameterProtocol?, navigationService: NavigationServiceProtocol?) -> MVVMPair {
        return configure(withData: withData, navigationService: navigationService, flow: nil)
    }
}


