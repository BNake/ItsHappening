//
//  HomeViewModel.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/4/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit

class HomeViewModel: BaseViewModel {
    
    let router: HomeRouter
    
    init(router: HomeRouter) {
        self.router = router
    }
}
