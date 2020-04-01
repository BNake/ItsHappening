//
//  FirebaseAuthService.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/26/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import FirebaseUI
private let keyFinishedLoginFlow = "keyFinishedLoginFlow"

class FirebaseAuthService: NSObject {
    
    // MARK: singleTon exposed instance
    static let sharedInstance = FirebaseAuthService()
    
    private(set) var firebaseAuth: Auth
    private(set) var loggedInUser: HappeningUser?
    private weak var navigationService: LinearNavigationService<HappeningNavigationController>?
    
    private(set) var finishedLoginFlow: Bool {
        didSet {
            UserDefaults.standard.set(finishedLoginFlow, forKey: keyFinishedLoginFlow)
        }
    }
    
    // MARK: init
    private override init() {
        
        firebaseAuth = Auth.auth()
        loggedInUser = nil
        finishedLoginFlow = UserDefaults.standard.bool(forKey: keyFinishedLoginFlow)
        super.init()
        debugPrint("init. \(self)")
        
    }
    
    func showFUILogin(navServ: NavigationServiceProtocol) {
        navigationService = navServ as? LinearNavigationService
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
    
    func sendVerificationCode(success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        guard let user = firebaseAuth.currentUser else {
            failure(DisplayError.init(code: .DENIED, message: "Must be Loged in to send email verification"))
            return
        }
        user.sendEmailVerification(completion: { (error) in
            if let e = error {
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
    
    func reloadUserData(success: @escaping () -> Void,
                         failure: @escaping (Error) -> Void) {
        
        firebaseAuth.currentUser?.reload(completion: { (error) in
            if let e = error {
                failure(e)
            } else {
                debugPrint("user data reloaded. \(self)")
                success()
            }
        })
    }
    
    func isLoggedIn() -> Bool {
        return firebaseAuth.currentUser != nil
    }
    
    func logout() {
        do {
            try firebaseAuth.signOut()
            loggedInUser = nil
            debugPrint("loggout. \(self)")
        } catch let error {
            debugPrint(error)
        }
    }
    
}

extension FirebaseAuthService: FUIAuthDelegate {

    // MARK: called when Firebase Auth UI finishes

    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
        if error != nil {
            debugPrint("canceled Firebase UI login \(self)")
            return
        }
        
        debugPrint("logged in")
        let flow = LoginFlow()
        guard let firstViewModel = flow.firstViewModel() else { return }
        let _: LinearNavigationService? = navigationService?.presentService(viewModel: firstViewModel,
                                                                            with: nil,
                                                                            flow: flow)
    }

}
