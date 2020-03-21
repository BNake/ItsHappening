//
//  TutorialPageConfigurator.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/21/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit

final class TutorialPageConfigurator: ConfiguratorProtocol {
    
    func configure(withData data: ParameterProtocol?, navigationService: NavigationServiceProtocol?, flow: FlowProtocol?) -> MVVMPair {
        let viewController = TutorialPageViewController()
        let viewModel = data as! TutorialPageViewModel
        viewController.setup(viewModel: viewModel)
        return (viewController, viewModel)
    }
    
    func configure(withData: ParameterProtocol?, navigationService: NavigationServiceProtocol?) -> MVVMPair {
        return configure(withData: withData, navigationService: navigationService, flow: nil)
    }
    
}
