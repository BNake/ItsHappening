//
//  RowViewModel.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/7/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RowViewModel: ViewModelProtocol {
    
    lazy private(set) var disposeBag = DisposeBag()
    var selection: Action?

    init(selection: Action? = nil) {
        self.selection = selection
    }
    
    func selectionExecute() {
        selection?()
    }
}

