//
//  ContactViewModel.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/27/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//
import RxCocoa
import RxSwift
import InstantSearchClient

class ContactViewModel: BaseViewModel {
    
    let router: ContactRouter
    private var usersDisposedBag = DisposeBag()

    let searchText = BehaviorRelay<String>(value: "")

    private let sectionViewModels = BehaviorRelay<[SectionViewModel]>(value: [])
    var sectionViewModelsDriver: Driver<[SectionViewModel]> {
        return sectionViewModels.asDriver(onErrorJustReturn: [])
    }
    
    init(router: ContactRouter) {
        self.router = router
        super.init()
        setupData()
    }
    
    func searchCollection(forText searchString : String) {
        
        let usersTable = FirebaseFireStoreService<HappeningUser>(collectionName: "Users")

        usersTable.search(queryString: searchString,
                          attributesToRetrieve: ["firstName", "lastName", "username", "profileImageUrl"],
                          maxCount: 20,
                          success: { [weak self] (users) in
                               
                            guard let self = self else { return }
                            self.updateUI(rows: self.makeRows(from: users))
                            
                          }) { (error) in
                               debugPrint(error)
                          }
        
    }
    
    private func setupData() {
        searchText
            .throttle(RxTimeInterval.milliseconds(1000), scheduler: MainScheduler.instance)
            .subscribe(onNext: { (queries) in
                self.searchCollection(forText: queries)
        }).disposed(by: disposeBag)
    }
    
    private func makeRows(from users: [HappeningUser]) -> [ContactCellViewModel] {
        var rows: [ContactCellViewModel] = []
        usersDisposedBag = DisposeBag()
        
        for user in users {
            let row = ContactCellViewModel(user: user)
            rows.append(row)
        }
        return rows
    }
    
    private func updateUI(rows: [ContactCellViewModel]) {
        var sections: [SectionViewModel] = []
        let mainSection = SectionViewModel(viewModels: rows)
        sections.append(mainSection)
        self.sectionViewModels.accept(sections)
    }
}
