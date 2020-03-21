//
//  HappeningNavigationController.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/20/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit

class HappeningNavigationController: UINavigationController, NavigationControllerProtocol {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

class HappeningTabBarController: UITabBarController, NavigationControllerProtocol {
}
