//
//  BaseRouter.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/20/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

protocol RouterProtocol: AnyObject {
    
    init(navigationService: NavigationServiceProtocol,
         flow: FlowProtocol?)
    
    func showViewModel<T: ViewModelProtocol>(_ type: T.Type,
                                        with: ParameterProtocol?,
                                        flow: FlowProtocol?,
                                        completion: Action?)
    
    func showViewModel<T: ViewModelProtocol>(_ type: T,
                                        with: ParameterProtocol?,
                                        flow: FlowProtocol?,
                                        completion: Action?)
    
    func present<T: ViewModelProtocol>(viewModel: T.Type,
                                    with: ParameterProtocol?,
                                    flow: FlowProtocol?,
                                    style: PresentationStyle,
                                    completion: Action?)
    
    func presentService<T: ViewModelProtocol>(viewModel: T.Type,
                                          with: ParameterProtocol?,
                                          flow: FlowProtocol?,
                                          style: PresentationStyle,
                                          completion: Action?)
    
    func closePresented(completion: Action?)
    
    func close<T: ViewModelProtocol>(_ : T, completion: Action?)
    func remove<T: ViewModelProtocol>(_ : T)
    func remove<T: ViewModelProtocol>(_ : T.Type)
    
    func next<T: BaseViewModel>(_ : T, with: ParameterProtocol?)
    func breakFlow<T: BaseViewModel>(_ viewModel: T, with data: ParameterProtocol?)
}

extension RouterProtocol {
    init(navigationService: NavigationServiceProtocol) {
        self.init(navigationService: navigationService, flow: nil)
    }
    
    func showViewModel<T: ViewModelProtocol>(_ type: T.Type,
                                        with: ParameterProtocol? = nil,
                                        flow: FlowProtocol? = nil) {
        
        showViewModel(type,
                      with: with,
                      flow: flow,
                      completion: nil)
    }
    
    func showViewModel<T: ViewModelProtocol>(_ type: T.Type,
                                        completion: Action? = nil) {
        
        showViewModel(type,
                      with: nil,
                      flow: nil,
                      completion: completion)
    }
    
    func showViewModel<T: ViewModelProtocol>(_ viewModel: T) {
        
        showViewModel(viewModel,
                      with: nil,
                      flow: nil,
                      completion: nil)
    }
    
    func present<T: ViewModelProtocol>(viewModel: T.Type,
                                       with: ParameterProtocol? = nil,
                                       style: PresentationStyle = .fullscreen,
                                       completion: Action? = nil) {
        
        present(viewModel: viewModel,
                with: with,
                flow: nil,
                style: style,
                completion: completion)
    }
    
    func presentService<T: ViewModelProtocol>(viewModel: T.Type,
                                         with: ParameterProtocol? = nil,
                                         style: PresentationStyle = .fullscreen,
                                         completion: Action? = nil) {
        
        present(viewModel: viewModel,
                with: with,
                flow: nil,
                style: style,
                completion: completion)
    }
    
    func closePresented() {
        closePresented(completion: nil)
    }
    
    func close<T: ViewModelProtocol>(_ viewModel: T) {
        close(viewModel, completion: nil)
    }
}

class BaseRouter: RouterProtocol {
    
    let flow: FlowProtocol?
    private(set) var navigationService: NavigationServiceProtocol
    
    required init(navigationService: NavigationServiceProtocol, flow: FlowProtocol?) {
        self.navigationService = navigationService
        self.flow = flow
    }
    
    deinit {
        debugPrint("deinit ---- \(self) ----")
    }
    
    func showViewModel<T: ViewModelProtocol>(_ type: T.Type,
                                        with data: ParameterProtocol?,
                                        flow: FlowProtocol?,
                                        completion: Action?) {
        
        navigationService.show(viewModel: type,
                               with: data,
                               flow: flow,
                               completion: completion)
    }
    
    func showViewModel<T: ViewModelProtocol>(_ viewModel: T,
                                        with data: ParameterProtocol?,
                                        flow: FlowProtocol?,
                                        completion: Action?) {
        
        navigationService.show(viewModel: viewModel,
                               with: data,
                               flow: flow,
                               completion: completion)
    }
    
    func close<T: ViewModelProtocol>(_ viewModel: T, completion: Action?) {
        navigationService.popViewModel(completion: completion)
    }
    
    func remove<T: ViewModelProtocol>(_ viewModel: T) {
        navigationService.remove(viewModel: viewModel)
    }
    
    func remove<T: ViewModelProtocol>(_ viewModel: T.Type) {
        navigationService.remove(viewModel: viewModel)
    }
    
    func present<T: ViewModelProtocol>(viewModel: T.Type,
                                   with: ParameterProtocol?,
                                   flow: FlowProtocol?,
                                   style: PresentationStyle = .fullscreen,
                                   completion: Action?) {
        
        navigationService.present(viewModel: viewModel,
                                  with: with,
                                  flow: flow,
                                  style: style,
                                  completion: completion)
    }
    
    func presentService<T>(viewModel: T.Type,
                        with: ParameterProtocol?,
                        flow: FlowProtocol?,
                        style: PresentationStyle,
                        completion: Action?) where T : ViewModelProtocol {
        
        let _: LinearNavigationService? = navigationService.presentService(
            viewModel: viewModel,
            with: with,
            flow: flow,
            style: style,
            completion: completion)
    }
    
    func closePresented(completion: Action?) {
        navigationService.closePresentedService(completion: completion)
    }
    
    // MARK: - Flow
    
    func next<T: BaseViewModel>(_ viewModel: T, with data: ParameterProtocol?) {
        debugPrint("next")
        if let flow = flow {
            flow.nextStep(viewModel: viewModel, router: self, data: data)
        } else {
            fatalError("If you use this method. You must have a Flow.")
        }
    }
    
    func breakFlow<T: BaseViewModel>(_ viewModel: T, with data: ParameterProtocol?) {
        if let flow = flow {
            flow.breakFlow(viewModel: viewModel, router: self)
        } else {
            fatalError("If you use this method. You must have a Flow.")
        }
    }
}


