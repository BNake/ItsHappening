//
//  BaseFlow.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/20/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit

// extension ParameterProtocol {
//
//     var flow: BaseFlow? {
//         return nil
//     }
//
// }

protocol FlowProtocol: AnyObject {
    var breakAction: Action? { get  set }
    var finishAction: Action? { get set }
    func nextStep(viewModel: BaseViewModel, router: BaseRouter, data: ParameterProtocol?)
    func breakFlow(viewModel: BaseViewModel, router: BaseRouter)
    func finishFlow(viewModel: BaseViewModel, router: BaseRouter)
}

extension FlowProtocol {
    func nextStep(viewModel: BaseViewModel, router: BaseRouter) {
        self.nextStep(viewModel: viewModel, router: router, data: nil)
    }
}

class BaseFlow: FlowProtocol {
    var breakAction: Action?
    var finishAction: Action?
    
    init(breakAction: Action? = nil, finishAction: Action? = nil) {
        self.breakAction = breakAction
        self.finishAction = finishAction
    }
    
    deinit {
        debugPrint("deinit --- \(self) ----")
    }
    
    func startFlow(router: RouterProtocol, data: ParameterProtocol?) {
        
    }
    
    func nextStep(viewModel: BaseViewModel, router: BaseRouter, data: ParameterProtocol?) {
        
    }
    
    func breakFlow(viewModel: BaseViewModel, router: BaseRouter) {
        self.breakAction?()
    }
    
    func finishFlow(viewModel: BaseViewModel, router: BaseRouter) {
        self.finishAction?()
    }
}


