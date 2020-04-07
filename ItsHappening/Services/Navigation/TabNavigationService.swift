//
//  TabNavigationService.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/6/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit

class TabNavigationService<N: HappeningTabBarController>: NavigationServiceProtocol {
    
    private var parentNavigation: NavigationServiceProtocol?
    private weak var tabBarController: N?
    
    required init<T: NavigationControllerProtocol>(navigationController: T) {
        tabBarController = navigationController as! N
    }
    
    func navigationController<T>() -> T where T: UIViewController {
        return tabBarController as! T
    }
    
    func show<T>(viewModel: T.Type, with: ParameterProtocol?, flow: FlowProtocol?, completion: Action? = nil) where T: ViewModelProtocol {
        
    }
    
    func show<T: ViewModelProtocol>(viewModel: T, with: ParameterProtocol?, flow: FlowProtocol?, completion: Action?) {
        tabBarController?.viewControllers?
            .compactMap { $0 as? ViewModelEqualityProtocol }
            .first { $0.compareViewModel(with: viewModel) }
            .map { $0 as? UIViewController}
            .map { $0.map { [weak self] vc in
                    if let index = self?.tabBarController?.viewControllers?.firstIndex(of: vc) {
                        self?.tabBarController?.selectedIndex = index
                        completion?()
                    }
                }
        }
    }
    
    func push<T>(viewModel: T.Type, with data: ParameterProtocol?, flow: FlowProtocol?, completion: Action? = nil) where T: ViewModelProtocol {
        parentNavigation?.push(viewModel: viewModel, with: data, flow: flow, completion: completion)
    }
    
    func present<T: ViewModelProtocol>(viewModel type: T.Type, with data: ParameterProtocol?,
                                       flow: FlowProtocol?, style: PresentationStyle, completion: Action? = nil) {
        let configurator = ConfiguratorContainer.shared.resolve(for: type)
        let (viewController, _) = configurator.configure(withData: data, navigationService: self, flow: flow)
        viewController.modalPresentationStyle = style.modalPresentationStyle()
        tabBarController?.present(viewController, animated: true, completion: nil)
    }
    
    func presentService<T: ViewModelProtocol, T1: NavigationServiceProtocol>(viewModel type: T.Type,
                                                                             with data: ParameterProtocol?,
                                                                             flow: FlowProtocol?,
                                                                             style: PresentationStyle = .fullscreen,
                                                                             completion: Action? = nil) -> T1 {
        let navigationController = HappeningNavigationController()
        let navigationService: T1 = createChildNavigation(navigationController: navigationController)
        navigationService.push(viewModel: type, with: data, flow: flow, completion: completion)
        let navigationVC = navigationService.navigationController()
        navigationVC.modalPresentationStyle = style.modalPresentationStyle()
        tabBarController?.present(navigationVC, animated: true, completion: nil)
        return navigationService
    }
    
    func remove<T>(viewModel: T) where T: ViewModelProtocol {
        
    }
    
    func remove<T>(viewModel: T.Type) where T : ViewModelProtocol {
        
    }
    
    func popTo<T>(viewModel: T, completion: Action? = nil) where T: ViewModelProtocol {
        
    }
    
    func popViewModel(completion: Action? = nil) {
        
    }
    
    func closePresented<T>(viewModel: T, completion: Action? = nil) where T: ViewModelProtocol {
        
    }
    
    func closePresentedService(completion: Action? = nil) {
        
    }
    
    func createChildNavigation<T: NavigationServiceProtocol, N: NavigationControllerProtocol>(navigationController: N) -> T {
        let navigationService = T(navigationController: navigationController)
        navigationService.setParentNavigation(self)
        let navigationController = navigationService.navigationController()
        
        if tabBarController?.viewControllers == nil {
            tabBarController?.viewControllers = [navigationController]
        } else {
            tabBarController?.viewControllers?.append(navigationController)
        }
        return navigationService
    }
    
    func setParentNavigation(_ parent: NavigationServiceProtocol) {
        parentNavigation = parent
    }
    
    func getParentNavigation() -> NavigationServiceProtocol? {
        return parentNavigation
    }
}

