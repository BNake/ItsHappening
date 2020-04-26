//
//  BaseViewModel.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/20/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import RxSwift
import RxCocoa

// MARK: - ViewModelProtocol

protocol ViewModelProtocol: AnyObject, PreparableProtocol, MirrorProtocol, ShowErrorsProtocol, ParameterProtocol {}

protocol ShowErrorsProtocol {

    var blockedErrorDriver: Driver<DisplayError> { get }
    var infoErrorDriver: Driver<DisplayError> { get }
    var systemDialogDriver: Driver<DialogObject> { get }
    var isLoadingDriver: Driver<Bool> { get }
}

extension ShowErrorsProtocol {

    var blockedErrorDriver: Driver<DisplayError> {
        return .empty()
    }
    
    var infoErrorDriver: Driver<DisplayError> {
        return .empty()
    }
    
    var systemDialogDriver: Driver<DialogObject> {
        return .empty()
    }
    
    var isLoadingDriver: Driver<Bool> {
        return .empty()
    }
}

class BaseViewModel: NSObject, ViewModelProtocol {
    lazy private(set) var disposeBag = DisposeBag()

    let displayBlockedError = PublishRelay<DisplayError>()
    var blockedErrorDriver: Driver<DisplayError> {
        return displayBlockedError.asDriver(onErrorDriveWith: .empty())
    }

    let displayInfoError = PublishRelay<DisplayError>()
    var infoErrorDriver: Driver<DisplayError> {
        return displayInfoError.asDriver(onErrorDriveWith: .empty())
    }
    
    let displaySystemDialog = PublishRelay<DialogObject>()
    var systemDialogDriver: Driver<DialogObject> {
        return displaySystemDialog.asDriver(onErrorDriveWith: .empty())
    }
    
    let isLoading = BehaviorRelay<Bool>(value: false)
    var isLoadingDriver: Driver<Bool> {
        return isLoading.asDriver(onErrorDriveWith: .empty())
    }
    
    func prepare(with: ParameterProtocol?) {
        // You should override this method in child
        // for preparing view model with any data you've pased
    }

    override init() {
        
    }
    
    deinit {
        debugPrint("deinit ---- \(self) ----")
    }

}


