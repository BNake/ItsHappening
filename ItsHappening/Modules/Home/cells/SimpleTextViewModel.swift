//
//  SimpleTextViewModel.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/26/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import RxSwift
import RxCocoa

class SimpleTextViewModel: RowViewModel {

    let title: BehaviorRelay<String>
    init(title: String, selection: Action? = nil) {
        self.title = BehaviorRelay<String>(value: title)
        super.init(selection: selection)
    }
}
