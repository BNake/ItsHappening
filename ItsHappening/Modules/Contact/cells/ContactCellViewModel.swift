//
//  ContactCellViewModel.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/27/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import RxSwift
import RxCocoa

class ContactCellViewModel: RowViewModel {
    
    let user: HappeningUser
    // MARK: apearance
    
    private let username = BehaviorRelay<String>(value: "username")
    var usernameDriver: Driver<String> {
        return username.asDriver()
    }

    private let name = BehaviorRelay<String>(value: "name")
    var nameDriver: Driver<String> {
        return name.asDriver()
    }

    private let profileImageUrl = BehaviorRelay<URL?>(value: nil)
    var profileImageUrlDriver: Driver<URL?> {
        return profileImageUrl.asDriver()
    }
    
    init(user: HappeningUser, selection: Action? = nil) {
        self.user = user
        super.init(selection: selection)
        self.setUp()
    }
    
    private func setUp() {
        username.accept(user.username)
        name.accept(user.getFullName())
        profileImageUrl.accept(URL(string: user.profileImageUrl ?? ""))
    }
    
}
