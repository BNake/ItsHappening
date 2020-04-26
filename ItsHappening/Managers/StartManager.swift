//
//  StartManager.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/20/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit

extension StartManager {
    struct Const {
        static let launchScreenIdentifier = "LaunchScreen"
    }
}

class StartManager {

    var rootNavigationService: LinearNavigationService<HappeningNavigationController>!
    
    static let sharedInstance = StartManager()
    
    private init() {}

    func launchScreenVC() -> UIViewController {
        let storyboard = UIStoryboard(name: Const.launchScreenIdentifier, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: Const.launchScreenIdentifier)
    }
    
    func setupFirstVC() {
        
        setupUI()
        startAllServices { [weak self] in
            self?.showFirstVC()
        }
        
    }
    
    private func showFirstVC() {
        let navVC = HappeningNavigationController()
        self.rootNavigationService = LinearNavigationService<HappeningNavigationController>(navigationController: navVC)
        
        if !FirebaseAuthService.sharedInstance.finishedLoginFlow {
            FirebaseAuthService.sharedInstance.logout()
        }
        
        // present fist view controller
        let startViewModel = FirebaseAuthService.sharedInstance.finishedLoginFlow &&
                             FirebaseAuthService.sharedInstance.isLoggedIn() ?
                                MainViewModel.self :
                                LoginOptionsViewModel.self
        
        self.rootNavigationService.push(viewModel: startViewModel.self, flow: nil)
        
        // set first vc as root vc
        UIApplication.shared.keyWindow?.rootViewController = self.rootNavigationService.navigationController()
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
    }
    
    private func setupUI() {
        // Set NavigationBar Colors
        
        if #available(iOS 13, *) {
            let coloredAppearance = UINavigationBarAppearance()
            coloredAppearance.configureWithDefaultBackground()
            coloredAppearance.backgroundColor = ColorManager.hWhite
            coloredAppearance.titleTextAttributes = [.foregroundColor: ColorManager.hBlack]
            coloredAppearance.largeTitleTextAttributes = [.foregroundColor: ColorManager.hBlack]
            
            UINavigationBar.appearance().standardAppearance = coloredAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        } else {
            UINavigationBar.appearance().barTintColor = ColorManager.hWhite
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: ColorManager.hBlack]
            UINavigationBar.appearance().barStyle = .black
            UINavigationBar.appearance().isTranslucent = false
            UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = ColorManager.hBlack
        }
        UINavigationBar.appearance().tintColor = ColorManager.hBlack
    }
    
    func startAllServices(completion: @escaping () -> Void) {
        
        // load user data if authorized
        FirebaseAuthService.sharedInstance.loadUserData { _ in
            completion()
        }
    }
    
}


