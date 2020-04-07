//
//  ConfiguratorContainer.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/20/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit

typealias MVVMPair = (viewController: UIViewController, viewModel: ViewModelProtocol)

protocol ParameterProtocol {

}

//protocol FlowProtocol {
//    var flow: BaseFlow? { get }
//}

protocol InitiableProtocol {
    init()
}

protocol ConfiguratorProtocol: InitiableProtocol {
    func configure(withData: ParameterProtocol?, navigationService: NavigationServiceProtocol?) -> MVVMPair
    func configure(withData: ParameterProtocol?, navigationService: NavigationServiceProtocol?, flow: FlowProtocol?) -> MVVMPair
}
extension ConfiguratorProtocol {
    func configure(withData: ParameterProtocol?, navigationService: NavigationServiceProtocol?) -> MVVMPair {
        return configure(withData: withData, navigationService: navigationService, flow: nil)
    }
}

class ConfiguratorContainer {

    static let shared = ConfiguratorContainer()
    private var configurators: [String: ConfiguratorProtocol] = [:]
    
    private init() {
        
        configurators[String(describing: LoginOptionsViewModel.self)] = LoginOptionsConfigurator()
        configurators[String(describing: TutorialPageViewModel.self)] = TutorialPageConfigurator()
        configurators[String(describing: LoginViewModel.self)] = LoginConfigurator()
        configurators[String(describing: VerifyEmailViewModel.self)] = VerifyEmailConfigurator()
        configurators[String(describing: ProfileViewModel.self)] = ProfileConfigurator()
        configurators[String(describing: HomeViewModel.self)] = HomeConfigurator()
        configurators[String(describing: MainViewModel.self)] = MainConfigurator()

    }
    
    func resolve<T: ViewModelProtocol>(for type: T.Type) -> ConfiguratorProtocol {
        guard let configurator = configurators[String(describing: type)] else {
            fatalError("Need to add your viewModel type to ConfiguratorContainer dictionary")
        }
        return configurator
    }

}


