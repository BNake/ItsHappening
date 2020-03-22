//
//  LoginOptionsConfigurator.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/21/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit

final class LoginOptionsConfigurator: ConfiguratorProtocol {
    
    func configure(withData: ParameterProtocol?, navigationService: NavigationServiceProtocol?, flow: FlowProtocol?) -> MVVMPair {
        let viewController = LoginOptionsViewController()
        let router = LoginOptionsRouter(navigationService: navigationService!, flow: flow)
        let viewModel = LoginOptionsViewModel(router: router)
        viewController.setup(viewModel: viewModel)
        
        viewController.tutorialPages = viewModel.tutorialPagesViewModels.map { dataModel  in
            let configurator = ConfiguratorContainer.shared.resolve(for: TutorialPageViewModel.self)
            let pageMVVMPair = configurator.configure(withData: dataModel, navigationService: nil)
            return pageMVVMPair.viewController
        }
        
        return (viewController, viewModel)
    }
    
    func configure(withData: ParameterProtocol?, navigationService: NavigationServiceProtocol?) -> MVVMPair {
        return configure(withData: withData, navigationService: navigationService, flow: nil)
    }
}


