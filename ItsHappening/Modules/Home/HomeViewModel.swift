//
//  HomeViewModel.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/4/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import RxCocoa
import RxSwift

class HomeViewModel: BaseViewModel {
    
    private var usersDisposedBag = DisposeBag()

    let router: HomeRouter
    private let sectionViewModels = BehaviorRelay<[SectionViewModel]>(value: [])
    var sectionViewModelsDriver: Driver<[SectionViewModel]> {
        return sectionViewModels.asDriver(onErrorJustReturn: [])
    }

    init(router: HomeRouter) {
        self.router = router
        super.init()
        setupData()
    }
    
    private func setupData() {
        let usersTable = FirebaseFireStoreService<HappeningUser>(collectionName: "Users")

        usersTable.getDocuments(success: { (users) in

            let rows = self.makeRows(from: users)
            var sections: [SectionViewModel] = []

            let mainSection = SectionViewModel(viewModels: rows)
            sections.append(mainSection)
            self.sectionViewModels.accept(sections)

        }) { (error) in

        }
    }

    // MARK: Binding

    private func binding() {
        
    }
    
    
    private func makeRows(from users: [HappeningUser]) -> [SimpleTextCellViewModel] {
        var rows: [SimpleTextCellViewModel] = []
        usersDisposedBag = DisposeBag()
        
        for user in users {
            let row = SimpleTextCellViewModel(title: user.firstName ?? "") {}
            rows.append(row)
        }
        return rows
    }
    
}
