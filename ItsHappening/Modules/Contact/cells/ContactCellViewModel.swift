//
//  ContactCellViewModel.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/27/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import RxSwift
import RxCocoa

struct ActionButtonModel {
    var title: String
    var isHidden: Bool
    var isActive: Bool
    var backgroundColor: UIColor
}

public enum ActionState {
    case following
    case notFollowing
    case pending
    case needApproval
    
    var model: ActionButtonModel {
        switch self {
        case .notFollowing:
            return ActionButtonModel(title: "Follow",
                                     isHidden: false,
                                     isActive: true,
                                     backgroundColor: ColorManager.hBlue)
        case .following:
            return ActionButtonModel(title: "",
                                     isHidden: true,
                                     isActive: false,
                                     backgroundColor: ColorManager.systemGreen)
        case .pending:
            return ActionButtonModel(title: "Pending",
                                     isHidden: false,
                                     isActive: true,
                                     backgroundColor: ColorManager.systemYellow)
        case .needApproval:
            return ActionButtonModel(title: "Accept",
                                     isHidden: false,
                                     isActive: true,
                                     backgroundColor: ColorManager.systemGreen)
        }
    }
}

class ContactCellViewModel: RowViewModel {
    
    let user: HappeningUser
    weak var navService: NavigationServiceProtocol?
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
    
    private let actionButtonText = BehaviorRelay<String>(value: "")
    var actionButtonTextDriver: Driver<String> {
        return actionButtonText.asDriver()
    }
    
    private let actionButtonState = BehaviorRelay<ActionState>(value: .notFollowing)
    var actionButtonStateDriver: Driver<ActionState> {
        return actionButtonState.asDriver()
    }
    
    let actionButtonCommand = PublishRelay<Void>()
    
    init(user: HappeningUser, navService: NavigationServiceProtocol?, selection: Action? = nil) {
        self.user = user
        self.navService = navService
        super.init(selection: selection)
        self.bind()
    }
    
    private func bind() {
        
        //
        // MARK: apearance
        //
        username.accept(user.username)
        name.accept(user.getFullName())
        profileImageUrl.accept(URL(string: user.profileImageUrl ?? ""))
        if let loggeduser = FirebaseAuthService.sharedInstance.loggedInUser.value {
            if loggeduser.idsOfUsersFollowing.contains(user.id) {
                actionButtonState.accept(.following)
            } else if loggeduser.idsOfUsersWhoRequestedToFollowYou.contains(user.id) {
                actionButtonState.accept(.needApproval)
            } else if loggeduser.idsOfUsersWhoYouRequestedToFollow.contains(user.id) {
                actionButtonState.accept(.pending)
            } else if loggeduser.id == user.id {
                actionButtonState.accept(.following)
            }
        }
        
        //
        // MARK: action
        //
        actionButtonCommand.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            switch self.actionButtonState.value {
            case .notFollowing:
                self.requestToFollow()
            case .needApproval:
                self.approveRequest()
            case .pending:
                break
            case .following:
                break
            }
            
        }).disposed(by: disposeBag)
    }
    
    private func requestToFollow() {
        guard FirebaseAuthService.sharedInstance.isLoggedIn(),
            let loggedInUser = FirebaseAuthService.sharedInstance.loggedInUser.value else {
            self.showLogin()
            return
        }
        let usersTable = FirebaseFireStoreService<HappeningUser>(collectionName: "Users")
        usersTable.updateArray(document: loggedInUser,
                               array: "idsOfUsersWhoYouRequestedToFollow",
                               newValue: user.id,
                               success: {
                                FirebaseAuthService.sharedInstance.loadUserData()
                               }) { (error) in
            
                               }
        usersTable.updateArray(document: user,
                               array: "idsOfUsersWhoRequestedToFollowYou",
                               newValue: loggedInUser.id,
                               success: {
                                FirebaseAuthService.sharedInstance.loadUserData()
                               }) { (error) in
            
                               }
    }
    
    private func approveRequest() {
        guard FirebaseAuthService.sharedInstance.isLoggedIn(),
            let loggedInUser = FirebaseAuthService.sharedInstance.loggedInUser.value else {
            self.showLogin()
            return
        }
        let usersTable = FirebaseFireStoreService<HappeningUser>(collectionName: "Users")
        usersTable.updateArray(document: loggedInUser,
                               array: "idsOfUsersFollowing",
                               newValue: user.id,
                               success: {
                                FirebaseAuthService.sharedInstance.loadUserData()
                               }) { (error) in
            
                               }
        usersTable.updateArray(document: user,
                               array: "idsOfUsersFollowing",
                               newValue: loggedInUser.id,
                               success: {
                                FirebaseAuthService.sharedInstance.loadUserData()
                               }) { (error) in
            
                               }
        usersTable.removeFromArray(document: loggedInUser,
                               array: "idsOfUsersWhoRequestedToFollowYou",
                               newValue: user.id,
                               success: {
                                FirebaseAuthService.sharedInstance.loadUserData()
                               }) { (error) in
            
                               }
        usersTable.removeFromArray(document: user,
                               array: "idsOfUsersWhoYouRequestedToFollow",
                               newValue: loggedInUser.id,
                               success: {
                                FirebaseAuthService.sharedInstance.loadUserData()
                               }) { (error) in
            
                               }
        
    }
    
    private func showLogin() {
        guard let nav = navService else { return }
        FirebaseAuthService.sharedInstance.showFUILogin(navServ: nav) {}
    }
    
}
