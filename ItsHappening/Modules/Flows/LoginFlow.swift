//
//  LoginFlow.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/29/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit

class LoginFlow: BaseFlow {
    
    var indexVM: Int = 0
    var viewModels : [(type: BaseViewModel.Type, data: ParameterProtocol?)] = []
    
    init() {
        super.init()
        createViewModelsFlow()
    }
    
    override func startFlow(router: RouterProtocol, data: ParameterProtocol?) {
        nextStep(viewModel: LoginViewModel(), router: router as! BaseRouter, data: nil)
    }
        
    func createViewModelsFlow() {
        indexVM = 0
        var viewModels : [(type: BaseViewModel.Type, data: ParameterProtocol?)] = []
                
        // MARK: - email sent
        if !FirebaseAuthService.sharedInstance.isEmailVerified() {
            viewModels.append((type: VerifyEmailViewModel.self, data: nil))
        }
        
        // MARK: - create profile
        if FirebaseAuthService.sharedInstance.loggedInUser.value == nil {
            viewModels.append((type: ProfileViewModel.self, data: nil))
        }
        
        self.viewModels = viewModels
    }
    
    override func nextStep(viewModel: BaseViewModel, router: BaseRouter, data: ParameterProtocol?) {
        self.chechNextStep(viewModel: viewModel, router: router, data: data)
    }
    
    func chechPreviousStep(previousViewModel: BaseViewModel, router: BaseRouter, data: ParameterProtocol?, next: @escaping Action) {
        switch previousViewModel {
        default:
            next()
        }
    }
    
    func chechNextStep(viewModel: BaseViewModel, router: BaseRouter, data: ParameterProtocol?) {
        self.chechPreviousStep(previousViewModel: viewModel, router: router, data: data) { [weak self] in
            self?.goNextStep(viewModel: viewModel, router: router, data: data)
        }
    }
    
    func goNextStep(viewModel: BaseViewModel, router: BaseRouter, data: ParameterProtocol?) {
        if indexVM >= viewModels.count {
            finishFlow(viewModel: viewModel, router: router)
        } else {
            let vm = viewModels[indexVM]
            switch vm.type {
            default:
                router.showViewModel(vm.type, with: vm.data, flow: self) { [weak router] in
                    router?.remove(viewModel)
                }
            }
            
            indexVM += 1
        }
    }
    
    override func finishFlow(viewModel: BaseViewModel, router: BaseRouter) {
        super.finishFlow(viewModel: viewModel, router: router)
    }
    
    override func breakFlow(viewModel: BaseViewModel, router: BaseRouter) {
        FirebaseAuthService.sharedInstance.logout()
        router.navigationService.closePresentedService()
        super.breakFlow(viewModel: viewModel, router: router)
    }
        
}
