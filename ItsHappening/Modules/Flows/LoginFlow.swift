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
    var needEnterPhone = false
        
    func createViewModelsFlow() {
        indexVM = 0
        var viewModels : [(type: BaseViewModel.Type, data: ParameterProtocol?)] = []
        
//        guard FirebaseAuthService.sharedInstance.isLoggedIn() else { return }
//        guard let userId = FirebaseAuthService.sharedInstance.firebaseAuth.currentUser?.uid else {
//            return
//        }
//        let usersTable = FirebaseFireStoreService<HappeningUser>(collectionName: "Users")
//        
//        usersTable.getDocument(documnetId: userId, success: { (user) in
//            
//            print("some user acuired")
//        }) { (error) in
//            
//            guard let displayError = error as? DisplayError else { return }
//            switch displayError.code {
//            case .Not_Found:
//                // go to create userName and the rest of the User info
//                self.router.next(self, with: nil)
//                break
//            case .Parse_Error:
//                // something must of happened with data
//                break
//            case .unknown:
//                // idk what happened here
//                break
//            case .DENIED:
//                break
//            }
//            
//        }
        
        // MARK: - Show email sent
        if let verified = FirebaseAuthService.sharedInstance.isEmailVerified(), !verified {
            viewModels.append((type: VerifyEmailViewModel.self, data: nil))
        }
        viewModels.append((type: VerifyEmailViewModel.self, data: nil))
        self.viewModels = viewModels
    }
    
    override func nextStep(viewModel: BaseViewModel, router: BaseRouter, data: ParameterProtocol?) {
        switch viewModel {
        case let viewModel as LoginOptionsViewModel:
            
            // Create array View Models for this flow Flow
            self.createViewModelsFlow()
            self.chechNextStep(viewModel: viewModel, router: router, data: data)
        default:
            self.chechNextStep(viewModel: viewModel, router: router, data: data)
        }
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
//        AuthManager.sharedInstance.doLogin()
//        NotificationCenter.default.post(name: .authLoginLogoutSuccessful, object: nil)
//        AuthManager.sharedInstance.doLogin()
//        router.navigationService.closePresentedService()
//        super.finishFlow(viewModel: viewModel, router: router)
    }
    
    override func breakFlow(viewModel: BaseViewModel, router: BaseRouter) {
        FirebaseAuthService.sharedInstance.logout()
        router.navigationService.closePresentedService()
        super.breakFlow(viewModel: viewModel, router: router)
    }
        
}

