//
//  ImagePickerConfigurator.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/26/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

final class ImagePickerConfigurator: ConfiguratorProtocol {
    
    func configure(withData: ParameterProtocol?,
                   navigationService: NavigationServiceProtocol?,
                   flow: FlowProtocol?) -> MVVMPair {
        let params = withData as? ImagePickerParams
        let vc = ImagePickerViewController()
        let router = ImagePickerRouter(navigationService: navigationService!, flow: flow)
        let vm = ImagePickerViewModel(router: router)
        vm.prepare(with: params)
        vc.setup(viewModel: vm)
        return (vc, vm)
    }
    
    func configure(withData: ParameterProtocol?,
                   navigationService: NavigationServiceProtocol?) -> MVVMPair {
        
        return configure(withData: withData,
                         navigationService: navigationService,
                         flow: nil)
    }
}

