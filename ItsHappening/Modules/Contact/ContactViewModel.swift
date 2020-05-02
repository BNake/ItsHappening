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
    
    enum SegmentControl {
        case all, friends
    }
    
    let router: ContactRouter
    private var usersDisposedBag = DisposeBag()

    let searchText = BehaviorRelay<String>(value: "")
    let segmentControlChanged = BehaviorRelay<SegmentControl>(value: .all)
    
    private let sectionViewModels = BehaviorRelay<[SectionViewModel]>(value: [])
    var sectionViewModelsDriver: Driver<[SectionViewModel]> {
        return sectionViewModels.asDriver(onErrorJustReturn: [])
    }
    
    private let friendsList = BehaviorRelay<[HappeningUser]>(value: [])
    
    init(router: ContactRouter) {
        self.router = router
        super.init()
        binding()
    }
    
    private func binding() {
        
        // bind the change in segment
        segmentControlChanged.bind { [weak self] (segmentedControl) in
            guard let self = self else { return }
            switch segmentedControl {
            case .all:
                self.searchAlgolia(forText: self.searchText.value)
            case .friends:
                self.showFriends()
            }
        }.disposed(by: disposeBag)
        
        // subscribe to searchbox
        searchText
            .throttle(RxTimeInterval.milliseconds(1000), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (queries) in
                guard let self = self else { return }
                switch self.segmentControlChanged.value {
                case.all:
                    self.searchAlgolia(forText: queries)
                case .friends:
                    break
                }
                
        }).disposed(by: disposeBag)
        
        // subscribe to friends list
        friendsList.bind { [weak self] (users) in
            guard let self = self else { return }
            self.reloadTableView(rows: self.makeRows(from: users))
        }.disposed(by: disposeBag)
    }
    
    func searchAlgolia(forText searchString : String) {
        
        let usersTable = FirebaseFireStoreService<HappeningUser>(collectionName: "Users")

        usersTable.search(queryString: searchString,
                          attributesToRetrieve: ["firstName",
                                                 "lastName",
                                                 "username",
                                                 "profileImageUrl"],
                          maxCount: 20,
                          success: { [weak self] (users) in
                               
                            guard let self = self else { return }
                            self.reloadTableView(rows: self.makeRows(from: users))
                            
                          }) { (error) in
                               debugPrint(error)
                          }
        
    }
    
    func showFriends() {
        
        guard FirebaseAuthService.sharedInstance.isLoggedIn() else { return }
        guard let user = FirebaseAuthService.sharedInstance.loggedInUser.value else { return }
        friendsList.accept([])
        
        let usersTable = FirebaseFireStoreService<HappeningUser>(collectionName: "Users")
        for id in user.idsOfUsersFollowing {
            usersTable.getDocument(documnetId: id, success: { [weak self] (user) in
                guard let self = self else { return }
                var friends = self.friendsList.value
                friends.append(user)
                self.friendsList.accept(friends)
            }) { (error) in
                debugPrint(error)
            }
        }
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
    
    private func reloadTableView(rows: [ContactCellViewModel]) {
        var sections: [SectionViewModel] = []
        let mainSection = SectionViewModel(viewModels: rows)
        sections.append(mainSection)
        self.sectionViewModels.accept(sections)
    }
}
