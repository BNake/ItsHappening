//
//  MainConfigurator.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/6/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

final class MainConfigurator: ConfiguratorProtocol {
    
    func configure(withData: ParameterProtocol?, navigationService: NavigationServiceProtocol?, flow: FlowProtocol?) -> MVVMPair {
        let mainVC = MainViewController()
        let mainNavigation = TabNavigationService<MainViewController>(navigationController: mainVC)
        let viewController: MainViewController = mainNavigation.navigationController()
        mainNavigation.setParentNavigation(navigationService!)
        
        let router = MainRouter(navigationService: mainNavigation, flow: flow)
        let viewModel = MainViewModel(router: router)
        viewController.setup(viewModel: viewModel)
        return (viewController, viewModel)
    }

    func configure(withData: ParameterProtocol?, navigationService: NavigationServiceProtocol?) -> MVVMPair {
        return configure(withData: withData, navigationService: navigationService, flow: nil)
    }
    
}


