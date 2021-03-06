//
//  ProfileViewModel.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/1/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewModel: BaseViewModel {
    
    let router: ProfileRouter
    
    // MARK: apearance
    
    private let logoText = BehaviorRelay<String>(value: "Social App")
    var logoTextDriver: Driver<String> {
        return logoText.asDriver()
    }
    
    private let logoImage = BehaviorRelay<UIImage>(value: UIImage(named: "logo")!)
    var logoImageDriver: Driver<UIImage> {
        return logoImage.asDriver()
    }
    
    private let titleText = BehaviorRelay<String>(value: "Create an Account")
    var titleTextDriver: Driver<String> {
        return titleText.asDriver()
    }
    
    private let profileImage = BehaviorRelay<UIImage>(value: UIImage(named: "add_profile_image")!)
    var profileImageDriver: Driver<UIImage> {
        return profileImage.asDriver()
    }
    
    let termsLink = "https://www.google.com"
    let privacyLink = "https://www.google.com"
    let termsAndServiceAttributedString = NSMutableAttributedString(string: "Terms Of Service and Privacy Policy")
    
    private lazy var termsText = BehaviorRelay<NSAttributedString>(value: termsAndServiceAttributedString)
    var termsTextDriver: Driver<NSAttributedString> {
        return termsText.asDriver()
    }
    
    private let saveButtonText = BehaviorRelay<String>(value: "Save")
    var saveButtonTextDriver: Driver<String> {
        return saveButtonText.asDriver()
    }
    
    // MARK: input
    
    let username = BehaviorRelay<String>(value: "")
    let firstName = BehaviorRelay<String>(value: "")
    let lastName = BehaviorRelay<String>(value: "")
    let phoneNumber = BehaviorRelay<String>(value: "")
    let profileImageURL = BehaviorRelay<String>(value: "")

    
    // MARK: validation
    var isAllInputValid: Observable<Bool>
    
    // MARK: Action
    
    let closeCommand = PublishRelay<Void>()
    let profileImageCommand = PublishRelay<Void>()
    let saveCommand = PublishRelay<Void>()
    
    init(router: ProfileRouter) {
        self.router = router
        
        // MARK: apearance
        if let termsRange = termsAndServiceAttributedString.string.range(of: "Terms Of Service"),
            let policyRance = termsAndServiceAttributedString.string.range(of: "Privacy Policy") {
            
            let trange = NSRange(termsRange, in: termsAndServiceAttributedString.string)
            let prange = NSRange(policyRance, in: termsAndServiceAttributedString.string)

            let linkAttributes: [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.foregroundColor: ColorManager.hBlue,
                NSAttributedString.Key.underlineStyle: 0,
                NSAttributedString.Key.underlineColor: ColorManager.hBlue
                //NSAttributedString.Key.link: termsLink
            ]
            termsAndServiceAttributedString.addAttributes(linkAttributes, range: trange)
            termsAndServiceAttributedString.addAttributes(linkAttributes, range: prange)
        }
        
        if let name = FirebaseAuthService.sharedInstance.firebaseAuth.currentUser?.displayName {
            let parts = name.split(separator: " ")
            if parts.count > 1 {
                let first = String(parts[0])
                let last = String(parts[1])
                firstName.accept(first)
                lastName.accept(last)
            }
        }
        
        if let phone = FirebaseAuthService.sharedInstance.firebaseAuth.currentUser?.phoneNumber {
            phoneNumber.accept(phone)
        }
                
        // MARK: validation
        isAllInputValid = Observable.combineLatest(username.asObservable(),
                                           firstName.asObservable(),
                                           lastName.asObservable(),
                                           phoneNumber.asObservable()) {
                                                                      username ,
                                                                      firstName,
                                                                      lastName,
                                                                      phoneNumber in
                                            
                                            let v = username.count > 5 &&
                                            firstName.count > 0 &&
                                            lastName.count > 0 &&
                                            phoneNumber.count > 10
                                            v ? debugPrint("valid") : debugPrint("not valid")// self.saveButtonText.accept("Valid") : self.saveButtonText.accept("NOT Valid")
                                            return v
        }
        super.init()
        
        // MARK: action
        closeCommand.subscribe(onNext: { [weak self] in
            self?.breakFlow()
        }).disposed(by: disposeBag)
        
        profileImageCommand.subscribe(onNext: { [weak self] _ in
            self?.showImageSelectionOptions()
        }).disposed(by: disposeBag)
        
        saveCommand.subscribe(onNext: { [weak self] in
            self?.saveUserProfile()
        }).disposed(by: disposeBag)
        
    }
    
    private func breakFlow() {
        router.breakFlow(self, with: nil)
    }
    
    private func next() {
        router.next(self, with: nil)
    }
    
    private func saveUserProfile() {
        
        guard let userId = FirebaseAuthService.sharedInstance.firebaseAuth.currentUser?.uid else { debugPrint("not logged in")
            return
        }
        
        guard let email = FirebaseAuthService.sharedInstance.firebaseAuth.currentUser?.email else { debugPrint("no email")
            return
        }

        let user = HappeningUser(id: userId,
                                 username: username.value,
                                 email: email,
                                 firstName: firstName.value,
                                 lastName: lastName.value,
                                 profileImageUrl: profileImageURL.value)
        
        let usersTable = FirebaseFireStoreService<HappeningUser>(collectionName: "Users")
        usersTable.set(document: user, success: { [weak self] in
            self?.next()
            
        }) { [weak self] (error) in
            self?.showError(error: error)
        }

    }
    
    private func saveProfileImage(image: UIImage) {
        guard let userId = FirebaseAuthService.sharedInstance.firebaseAuth.currentUser?.uid else { debugPrint("not logged in")
            return
        }
        
        FirebaseStorageService.sharedInstance.saveImageToStorage(
            image: image,
            storagePath: "profileImages/\(userId)",
            success: { [weak self] (url) in
                self?.profileImageURL.accept(url)
        }) { [weak self] (error) in
            self?.showError(error: error)
        }
    }
    
    private func showError(error: Error) {
        let ok = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        let alertParams = AlertParams(title: "Opps",
                                      message: error.localizedDescription,
                                      style: .alert,
                                      actionList: [ok])
        self.router.showAlert(alertParams: alertParams)
    }
    
    private func showImageSelectionOptions() {
        
        // Action Buttons
        
        let camera = UIAlertAction(title: "Camera", style: .default) { [weak self] (action) in
            self?.showSelectedImagePiker(source: .camera)
        }
        
        let gallery = UIAlertAction(title: "Gallery", style: .default) { [weak self] (action) in
            self?.showSelectedImagePiker(source: .photoLibrary)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default)
        
        // alert configs
        
        let params = AlertParams(title: "Select Image",
                                 message: "Options",
                                 style: .actionSheet,
                                 actionList: [gallery, camera, cancel])
        
        // show
        
        self.router.showAlert(alertParams: params)
    }
    
    private func showSelectedImagePiker(source: UIImagePickerController.SourceType) {
        let params = ImagePickerParams(source: source) { [weak self] (image) in
            self?.profileImage.accept(image)
            self?.saveProfileImage(image: image)
        }
        
        self.router.showImagePicker(imagePickerParams: params)
    }
}
