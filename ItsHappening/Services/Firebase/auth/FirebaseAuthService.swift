//
//  FirebaseAuthService.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/26/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import FirebaseUI
import RxSwift
import RxCocoa

private let keyFinishedLoginFlow = "keyFinishedLoginFlow"
public enum Status {
    case success
    case failed(errorCode: ErrorCode)
}
public typealias StatusCompletion = (Status) -> Void

class FirebaseAuthService: NSObject {
    
    // MARK: singleTon exposed instance
    static let sharedInstance = FirebaseAuthService()
    
    private(set) var firebaseAuth: Auth
    private(set) var loggedInUser: BehaviorRelay<HappeningUser?> = BehaviorRelay(value: nil)
    private weak var navigationService: LinearNavigationService<HappeningNavigationController>?
    
    private var postLoginfinishAction: Action = {}
    private(set) var finishedLoginFlow: Bool {
        didSet {
            UserDefaults.standard.set(finishedLoginFlow, forKey: keyFinishedLoginFlow)
        }
    }
    
    // MARK: init
    
    private override init() {
        
        firebaseAuth = Auth.auth()
        finishedLoginFlow = UserDefaults.standard.bool(forKey: keyFinishedLoginFlow)
        
        super.init()
        debugPrint("init ---- \(self) ----")
    }
        
    func loadUserData(completion: StatusCompletion? = nil) {
        
        reloadFirebaseAuthState { [weak self] _ in

            guard let loggedInUserId = self?.firebaseAuth.currentUser?.uid else {
                completion?(.failed(errorCode: .DENIED))
                return
            }
            let usersTable = FirebaseFireStoreService<HappeningUser>(collectionName: "Users")
            
            // attempt to get user from Firestore
            usersTable.getDocument(documnetId: loggedInUserId, success: { [weak self] (happeningUser) in
                
                self?.loggedInUser.accept(happeningUser)
                completion?(.success)
                
            }) { (error) in
                guard let e = error as? DisplayError else {
                    self?.loggedInUser.accept(nil)
                    self?.logout()
                    completion?(.failed(errorCode: .unknown))
                    return
                }
                completion?(.failed(errorCode: e.code))
            }
        }

    }
    
    func showFUILogin(navServ: NavigationServiceProtocol, finishAction: @escaping Action = {}) {
        navigationService = navServ as? LinearNavigationService
        postLoginfinishAction = finishAction
        let _: LinearNavigationService? = navigationService?.presentService(viewModel: LoginViewModel.self, with: nil, flow: nil)
    }
    
    func createUser(withEmail: String,
                    password: String,
                    success: @escaping () -> Void,
                    failure: @escaping (Error) -> Void) {
        
        let trimmedEmail = withEmail.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        firebaseAuth.createUser(withEmail: trimmedEmail, password: password) { (result, error) in
            if let e = error {
                failure(e)
            } else {
                debugPrint("user created. \(self)")
                success()
            }
        }
    }
    
    func login(withEmail: String,
                    password: String,
                    success: @escaping () -> Void,
                    failure: @escaping (Error) -> Void) {
        
        let trimmedEmail = withEmail.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        firebaseAuth.signIn(withEmail: trimmedEmail, password: password) { (result, error) in
            if let e = error {
                failure(e)
            } else {
                debugPrint("user logged in. \(self) ")
                success()
            }
        }

    }
    
    func sendVerificationCode(success: @escaping () -> Void = {}, failure: @escaping (Error) -> Void = { _ in }) {
        guard let user = firebaseAuth.currentUser else {
            failure(DisplayError.init(code: .DENIED, message: "Must be Loged in to send email verification"))
            return
        }
        user.sendEmailVerification(completion: { (error) in
            if let e = error {
                debugPrint("\(e) \(self) ")
                failure(e)
            } else {
                debugPrint("verification code sent. \(self) ")
                success()
            }
        })
    }
    
    func isEmailVerified() -> Bool {
        return firebaseAuth.currentUser?.isEmailVerified ?? false
    }
    
    func reloadFirebaseAuthState(completion: StatusCompletion? = nil) {
        
        guard let user = firebaseAuth.currentUser else {
            completion?(.failed(errorCode: .DENIED))
            return
        }
        user.reload(completion: { (error) in
            if error != nil {
                completion?(.failed(errorCode: .unknown))
                return
            }
            completion?(.success)
        })
    }
    
    func isLoggedIn() -> Bool {
        return firebaseAuth.currentUser != nil
    }
    
    func logout() {
        do {
            try firebaseAuth.signOut()
            loggedInUser.accept(nil)
            debugPrint("loggout. \(self)")
        } catch let error {
            debugPrint(error)
        }
    }
    
}

extension FirebaseAuthService: FUIAuthDelegate {

    // MARK: called when Firebase Auth UI finishes

    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
        if let e = error {
            debugPrint("\(e) \(self)")
            return
        }
        
        loadUserData { [weak self] (status) in
            self?.startFlow()
        }
    }
    
    private func startFlow() {
        let flow = LoginFlow()
        flow.finishAction =  { [weak self] in
            self?.loadUserData()
            self?.postLoginfinishAction()
            self?.finishedLoginFlow = true
        }
        flow.startFlow(router: LoginRouter(navigationService: navigationService!, flow: flow), data: nil)
    }
}
