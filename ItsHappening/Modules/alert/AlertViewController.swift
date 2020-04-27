//
//  ImagePickerViewController.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/26/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit

class AlertViewController: BaseAlertViewController<AlertViewModel> {
    
    override func setupUI() {
        
    }
    
    override func setupBinding() {
        
        viewModel.titleDriver.asObservable().subscribe(onNext: { [weak self] (title) in
            self?.title = title
        }).disposed(by: disposeBag)
        
        viewModel.actionListDriver.asObservable().subscribe(onNext: { [weak self] (actions) in
            actions.forEach { self?.addAction($0) }
        }).disposed(by: disposeBag)
        
        viewModel.messageDriver.asObservable().subscribe(onNext: { [weak self] (message) in
            self?.message = message
        }).disposed(by: disposeBag)
    }
}
