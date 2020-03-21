//
//  NavigationServiceProtocol.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/20/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit

typealias Action = () -> Void
typealias SelectionAction<T: ViewModelProtocol> = (T) -> Void

enum PresentationStyle {
    case fullscreen
    case overFullscreen
    
    func modalPresentationStyle() -> UIModalPresentationStyle {
        switch self {
        case .fullscreen:
            return UIModalPresentationStyle.fullScreen
        case .overFullscreen:
            return UIModalPresentationStyle.overFullScreen
        }
    }
}

protocol NavigationControllerProtocol {}

protocol NavigationServiceProtocol: AnyObject {
    
    init<N: NavigationControllerProtocol>(navigationController: N)
    func navigationController<T: UIViewController>() -> T
    
    //
    // show
    //
    func show<T: ViewModelProtocol>(viewModel: T.Type,
                                with: ParameterProtocol?,
                                flow: FlowProtocol?,
                                completion: Action?)
    
    func show<T: ViewModelProtocol>(viewModel: T,
                                with: ParameterProtocol?,
                                flow: FlowProtocol?,
                                completion: Action?)
    
    //
    // push
    //
    func push<T: ViewModelProtocol>(viewModel: T.Type,
                                with: ParameterProtocol?,
                                flow: FlowProtocol?,
                                completion: Action?)
    
    //
    // present
    //
    func present<T: ViewModelProtocol>(viewModel: T.Type,
                                   with: ParameterProtocol?,
                                   flow: FlowProtocol?,
                                   style: PresentationStyle,
                                   completion: Action?)
    
    func presentService<T: ViewModelProtocol, T1: NavigationServiceProtocol>(viewModel: T.Type,
                                                                     with: ParameterProtocol?,
                                                                     flow: FlowProtocol?,
                                                                     style: PresentationStyle,
                                                                     completion: Action?) -> T1
    
    //
    // remove
    //
    func remove<T: ViewModelProtocol>(viewModel: T)
    func remove<T: ViewModelProtocol>(viewModel: T.Type)
    func closePresentedService(completion: Action?)
    func popTo<T: ViewModelProtocol>(viewModel: T, completion: Action?)
    func popViewModel(completion: Action?)
    func closePresented<T: ViewModelProtocol>(viewModel: T, completion: Action?)
    
    //
    // create
    //
    func createChildNavigation<T: NavigationServiceProtocol, N: NavigationControllerProtocol>(navigationController: N) -> T
    func setParentNavigation(_ : NavigationServiceProtocol)
    func getParentNavigation() -> NavigationServiceProtocol?
}

extension NavigationServiceProtocol {
    
    //
    // show
    //
    func show<T: ViewModelProtocol>(viewModel: T.Type,
                                with: ParameterProtocol? = nil,
                                flow: FlowProtocol? = nil) {
        
        show(viewModel: viewModel,
             with: with,
             flow: flow,
             completion: nil)
    }
    
    func show<T: ViewModelProtocol>(viewModel: T,
                                with: ParameterProtocol? = nil,
                                flow: FlowProtocol? = nil) {
        
        show(viewModel: viewModel,
             with: with,
             flow: flow,
             completion: nil)
    }
    
    //
    // push
    //
    func push<T: ViewModelProtocol>(viewModel: T.Type,
                                with: ParameterProtocol? = nil,
                                flow: FlowProtocol? = nil) {
        
        push(viewModel: viewModel,
             with: with,
             flow: flow,
             completion: nil)
    }
    
    //
    // present
    //
    func present<T: ViewModelProtocol>(viewModel: T.Type,
                                   with: ParameterProtocol? = nil,
                                   flow: FlowProtocol? = nil,
                                   style: PresentationStyle = .fullscreen) {
        
        present(viewModel: viewModel,
                with: with,
                flow: flow,
                style: style,
                completion: nil)
    }
    
    func presentService<T: ViewModelProtocol, T1: NavigationServiceProtocol>(viewModel: T.Type,
                                                                     with: ParameterProtocol? = nil,
                                                                     flow: FlowProtocol? = nil,
                                                                     style: PresentationStyle = .fullscreen) -> T1 {
        
        presentService(viewModel: viewModel,
                       with: with,
                       flow: flow,
                       style: style,
                       completion: nil)
    }
    
    //
    // remove
    //
    func closePresented<T: ViewModelProtocol> (viewModel: T) {
        closePresented(viewModel: viewModel, completion: nil)
    }
    
    func closePresentedService() {
        closePresentedService(completion: nil)
    }
    
    func popViewModel() {
        popViewModel(completion: nil)
    }
    
    func popTo<T: ViewModelProtocol>(viewModel: T) {
        popTo(viewModel: viewModel, completion: nil)
    }
}


