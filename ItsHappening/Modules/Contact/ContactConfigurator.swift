//
//  ContactConfigurator.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/27/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

final class ContactConfigurator: ConfiguratorProtocol {
    
    func configure(withData: ParameterProtocol?,
                   navigationService: NavigationServiceProtocol?,
                   flow: FlowProtocol?) -> MVVMPair {
        
        let vc = ContactViewController()
        let router = ContactRouter(navigationService: navigationService!, flow: flow)
        let vm = ContactViewModel(router: router)
        vc.setup(viewModel: vm)
        return (vc, vm)
    }
    
    func configure(withData: ParameterProtocol?,
                   navigationService: NavigationServiceProtocol?) -> MVVMPair {
        
        return configure(withData: withData,
                         navigationService: navigationService,
                         flow: nil)
    }
}
