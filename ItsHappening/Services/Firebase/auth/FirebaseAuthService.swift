//
//  FirebaseAuthService.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/26/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import FirebaseAuth

class FirebaseAuthService {
    
    // MARK: singleTon exposed instance
    static let sharedInstance = FirebaseAuthService()
    
    private let firebaseAuth: Auth
    private(set) var loggedInUser: HappeningUser?
    
    // MARK: init
    private init() {
        
        firebaseAuth = Auth.auth()
        loggedInUser = nil
        debugPrint("\(self) init")
        
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
                debugPrint("\(self) user created")
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
                debugPrint("\(self) user logged in")
                success()
            }
        }

    }
    
    func sendVerificationCode(success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        firebaseAuth.currentUser?.sendEmailVerification(completion: { (error) in
            if let e = error {
                failure(e)
            } else {
                debugPrint("\(self) verification code sent.")
                success()
            }
        })
    }
    
    func isEmailVerified() -> Bool? {
        return firebaseAuth.currentUser?.isEmailVerified
    }
    
    func isLoggedIn() -> Bool {
        return firebaseAuth.currentUser != nil
    }
    
    func logout() {
        do {
            try firebaseAuth.signOut()
            loggedInUser = nil
            debugPrint("\(self) loggout.")
        } catch let error {
            debugPrint(error)
        }
    }
    
}
