//
//  ImagePickerViewModel.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/26/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//
import RxCocoa
import RxSwift

struct AlertParams: ParameterProtocol {
    let title: String
    let message: String
    let style: UIAlertController.Style
    let actionList: [UIAlertAction]
}

class AlertViewModel: BaseViewModel {
    
    let router: AlertRouter
    private(set) var alertParams: AlertParams?
    
    // MARK: out
    
    private let title = BehaviorRelay<String>(value: "")
    var titleDriver: Driver<String> {
        return title.asDriver()
    }
    
    private let message = BehaviorRelay<String>(value: "")
    var messageDriver: Driver<String> {
        return message.asDriver()
    }
    
    private let actionList = BehaviorRelay<[UIAlertAction]>(value: [])
    var actionListDriver: Driver<[UIAlertAction]> {
        return actionList.asDriver()
    }
    
    init(router: AlertRouter) {
        self.router = router
        super.init()
    }
    
    override func prepare(with: ParameterProtocol?) {
        self.alertParams = with as? AlertParams
        setUp()
    }
    
    private func setUp() {
        guard let params = self.alertParams else { return }
        
        title.accept(params.title)
        actionList.accept(params.actionList)
        message.accept(params.message)
    }
}
