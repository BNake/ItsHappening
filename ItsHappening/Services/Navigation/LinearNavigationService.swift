//
//  LinearNavigationService.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/20/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit

class LinearNavigationService<N: HappeningNavigationController>: NavigationServiceProtocol {
    
    private var parentNavigation: NavigationServiceProtocol?
    private weak var internalNavigationController: N?

    required init<T: NavigationControllerProtocol>(navigationController: T) {
        internalNavigationController = navigationController as! N
    }
    
    deinit {
        debugPrint("deinit \(self)")
    }
    
    func navigationController<T>() -> T where T: UIViewController {
        return self.internalNavigationController as! T
    }
    
    //
    // show
    //
    func show<T: ViewModelProtocol>(viewModel type: T.Type,
                                with data: ParameterProtocol? = nil,
                                flow: FlowProtocol? = nil,
                                completion: Action? = nil) {
        
        self.push(viewModel: type,
                  with: data,
                  flow: flow,
                  completion: completion)
    }
    
    func show<T: ViewModelProtocol>(viewModel: T,
                                with: ParameterProtocol?,
                                flow: FlowProtocol?,
                                completion: Action?) {
        
    }
    
    //
    // push
    //
    func push<T: ViewModelProtocol>(viewModel type: T.Type,
                                with data: ParameterProtocol? = nil,
                                flow: FlowProtocol? = nil,
                                completion: Action? = nil) {
        
        let configurator = ConfiguratorContainer.shared.resolve(for: type)
        let (viewController, _) = configurator.configure(withData: data, navigationService: self, flow: flow)
        internalNavigationController?.pushViewController(viewController, animated: true, completion: completion)
    }
    
    //
    // present
    //
    func present<T: ViewModelProtocol>(viewModel type: T.Type,
                                   with data: ParameterProtocol?,
                                   flow: FlowProtocol?,
                                   style: PresentationStyle,
                                   completion: Action?) {
        
        let configurator = ConfiguratorContainer.shared.resolve(for: type)
        let (viewController, _) = configurator.configure(withData: data, navigationService: self, flow: flow)
        viewController.modalPresentationStyle = style.modalPresentationStyle()
        internalNavigationController?.present(viewController, animated: true, completion: completion)
    }
    
    func presentService<T: ViewModelProtocol, T1: NavigationServiceProtocol>(viewModel type: T.Type,
                                                                     with data: ParameterProtocol? = nil,
                                                                     flow: FlowProtocol?,
                                                                     style: PresentationStyle = .fullscreen,
                                                                     completion: Action? = nil) -> T1 {
        let navigationController = N()
        let navigationService: T1 = createChildNavigation(navigationController: navigationController)
        navigationService.push(viewModel: type, with: data, flow: flow, completion: completion)
        let controller = navigationService.navigationController()
        controller.modalPresentationStyle = style.modalPresentationStyle()
        internalNavigationController?.present(controller, animated: true, completion: completion)
        return navigationService
    }
    
    //
    // remove
    //
    func remove<T: ViewModelProtocol>(viewModel: T) {
        var viewControllers = internalNavigationController?.viewControllers ?? []
        let firstCount = viewControllers.count
        _ = internalNavigationController?.viewControllers
            .compactMap { $0 as? ViewModelEqualityProtocol }
            .first { $0.compareViewModel(with: viewModel) }
            .map { $0 as? UIViewController}
            .map {vc in viewControllers.removeAll(where: {$0 == vc}) }
        internalNavigationController?.setViewControllers(viewControllers, animated: false)
        
        assert(viewControllers.count != firstCount, "\(viewModel) didn't remove at \(#function)")
    }
    
    func remove<T: ViewModelProtocol>(viewModel: T.Type) {
        var viewControllers = internalNavigationController?.viewControllers ?? []
        let firstCount = viewControllers.count
        
        internalNavigationController?.viewControllers
            .compactMap({$0 as? ViewModelEqualityProtocol})
            .first { $0.compareViewModel(withType: viewModel)}
            .map { $0 as? UIViewController}
            .map {vc in viewControllers.removeAll(where: {$0 == vc}) }
        internalNavigationController?.setViewControllers(viewControllers, animated: false)
        
        assert(viewControllers.count != firstCount, "\(viewModel) didn't remove at \(#function)")
    }
    
    func popTo<T: ViewModelProtocol>(viewModel: T, completion: Action? = nil) {
        internalNavigationController?.viewControllers
            .compactMap{$0 as? ViewModelEqualityProtocol}
            .first{$0.compareViewModel(with: viewModel)}
            .map{$0 as? UIViewController}
            .map{[weak self] vc in
                vc.map {
                    self?.internalNavigationController?.popToViewController($0, animated: true, completion: completion)
                }
        }
    }
    
    func popViewModel(completion: Action? = nil) {
        internalNavigationController?.popViewController(animated: true, completion: completion)
    }
    
    func closePresented<T: ViewModelProtocol>(viewModel: T, completion: Action? = nil) {
        internalNavigationController?.viewControllers
            .compactMap{$0 as? ViewModelEqualityProtocol}
            .first{$0.compareViewModel(with: viewModel)}
            .map{$0 as? UIViewController}
            .map{$0?.dismiss(animated: true, completion: completion) }
    }
    
    func closePresentedService(completion: Action? = nil) {
        internalNavigationController?.dismiss(animated: true, completion: completion)
    }
    
    //
    // create
    //
    func createChildNavigation<T: NavigationServiceProtocol, N: NavigationControllerProtocol>(navigationController: N) -> T {
        let navigation = T(navigationController: navigationController)
        navigation.setParentNavigation(self)
        return navigation
    }
    
    func setParentNavigation(_ parent: NavigationServiceProtocol) {
        parentNavigation = parent
    }
    
    func getParentNavigation() -> NavigationServiceProtocol? {
        return parentNavigation
    }
}


