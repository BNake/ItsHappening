//
//  SectionViewModel.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/7/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import RxSwift
import RxCocoa

class SectionViewModel: ViewModelProtocol {

    let rowViewModels: [RowViewModel]
    
    private var _name: BehaviorRelay<String>?
    public var name: Driver<String>? {
        return _name?.asDriver()
    }
    
    init(name: String? = nil, viewModels: [RowViewModel]) {
        if let name = name {
            _name = BehaviorRelay<String>(value: name)
        }
        self.rowViewModels = viewModels
    }
}

