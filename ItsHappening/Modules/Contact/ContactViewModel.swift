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
        case all, friends, pending
    }
    
    let router: ContactRouter
    private var usersDisposedBag = DisposeBag()

    // MARK: input 
    let searchText = BehaviorRelay<String>(value: "")
    let segmentControlChanged = BehaviorRelay<SegmentControl>(value: .all)
    
    // tableview datasource
    private let sectionViewModels = BehaviorRelay<[SectionViewModel]>(value: [])
    var sectionViewModelsDriver: Driver<[SectionViewModel]> {
        return sectionViewModels.asDriver(onErrorJustReturn: [])
    }
    
    // hide or show segmetedControl
    private let segmentedContolVisibility = BehaviorRelay<Bool>(value: false)
    var segmentedContolVisibilityDriver: Driver<Bool> {
        return segmentedContolVisibility.asDriver(onErrorJustReturn: false)
    }
    
    // segmented control position
    private let segmentedContolPosition = BehaviorRelay<Int>(value: 0)
    var segmentedContolPositionDriver: Driver<Int> {
        return segmentedContolPosition.asDriver(onErrorJustReturn: 0)
    }
    
    private let usersList = BehaviorRelay<[HappeningUser]>(value: [])
    
    init(router: ContactRouter) {
        self.router = router
        super.init()
        binding()
    }
    
    private func binding() {
        
        //
        // bind the change in segment
        //
        segmentControlChanged.bind { [weak self] (segmentedControl) in
            guard let self = self else { return }
            self.setMode(segment: segmentedControl, inputString: self.searchText.value)
        }.disposed(by: disposeBag)
        
        
        //
        // subscribe to searchbox
        //
        searchText
            // .throttle(RxTimeInterval.milliseconds(1000), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (inputString) in
                guard let self = self else { return }
                self.setMode(segment: self.segmentControlChanged.value, inputString: inputString)
        }).disposed(by: disposeBag)
        
        //
        // subscribe to the loggedin user
        //
        FirebaseAuthService.sharedInstance.loggedInUser.bind { [weak self] (loggedInUser) in
            guard let self = self else { return }
            guard loggedInUser != nil else {
                self.segmentControlChanged.accept(.all)
                self.segmentedContolVisibility.accept(false)
                return
            }
            self.segmentControlChanged.accept(self.segmentControlChanged.value)
            self.segmentedContolVisibility.accept(true)
        }.disposed(by: disposeBag)
        
        
        //
        // subscribe to users list
        //
        usersList.bind { [weak self] (users) in
            guard let self = self else { return }
            let rows = self.makeRows(from: users)
            self.reloadTableView(rows: rows)
        }.disposed(by: disposeBag)
    }
    
    func setMode(segment: SegmentControl, inputString: String) {
        switch segment {
        case.all:
            self.segmentedContolPosition.accept(0)
            self.searchAlgolia(forText: inputString) { (users) in
                self.usersList.accept(users)
            }
        case .friends:
            self.segmentedContolPosition.accept(1)
            self.searchAlgolia(forText: inputString) { (users) in
                guard let loggedInUser = FirebaseAuthService
                                                    .sharedInstance
                                                    .loggedInUser
                                                    .value else {
                        self.usersList.accept([])
                        return
                }
                
                let friendsOnly = users.filter { (user) -> Bool in
                    return loggedInUser.idsOfUsersFollowing.contains(user.id)
                }
                self.usersList.accept(friendsOnly)
            }
        case .pending:
            self.segmentedContolPosition.accept(2)
            self.searchAlgolia(forText: inputString) { (users) in
                guard let loggedInUser = FirebaseAuthService
                                                    .sharedInstance
                                                    .loggedInUser
                                                    .value else {
                        self.usersList.accept([])
                        return
                }
                
                let friendsOnly = users.filter { (user) -> Bool in
                    return loggedInUser.idsOfUsersWhoYouRequestedToFollow.contains(user.id) ||
                    loggedInUser.idsOfUsersWhoRequestedToFollowYou.contains(user.id)
                }
                self.usersList.accept(friendsOnly)
            }
        }
    }
    
    func searchAlgolia(forText searchString : String, result: @escaping ([HappeningUser]) -> Void) {
        
        let usersTable = FirebaseFireStoreService<HappeningUser>(collectionName: "Users")

        usersTable.search(queryString: searchString,
                          attributesToRetrieve: ["id",
                                                 "firstName",
                                                 "lastName",
                                                 "username",
                                                 "profileImageUrl"],
                          maxCount: 20,
                          success: { (users) in
                               result(users)
                          }) { (error) in
                               debugPrint(error)
                               result([])
                          }
        
    }
    
    private func makeRows(from users: [HappeningUser]) -> [ContactCellViewModel] {
        var rows: [ContactCellViewModel] = []
        usersDisposedBag = DisposeBag()
        
        for user in users {
            let row = ContactCellViewModel(user: user, navService: router.navigationService)
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
