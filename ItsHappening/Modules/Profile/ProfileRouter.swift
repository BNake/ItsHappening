//
//  ProfileRouter.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/1/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit

class ProfileRouter: BaseRouter {
    
    func showAlert(alertParams: AlertParams) {
        
        present(viewModel: AlertViewModel.self,
                with: alertParams,
                style: .fullscreen,
                completion: nil)
        
    }
    
    func showImagePicker(imagePickerParams: ImagePickerParams) {
        
        present(viewModel: ImagePickerViewModel.self,
                with: imagePickerParams,
                style: .fullscreen,
                completion: nil)
        
    }
}
