//
//  MainViewController.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/6/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit

class MainViewController: BaseTabBarViewController<MainViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        tabBar.tintColor = ColorManager.hBlue
        tabBar.tintAdjustmentMode = .normal

        self.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
}

extension MainViewController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        if selectedViewController === viewController, let navVC = viewController as? UINavigationController {
//            switch navVC.viewControllers.first {
//            case let historyVC as HomeViewController:
//                historyVC.tableView.setContentOffset(.zero, animated: true)
//            case let mapVC as MapViewController:
//                mapVC.siteListViewController.tableView.setContentOffset(.zero, animated: true)
//                mapVC.siteListPannableView.setState(.middle, animated: true)
//            case let homeVC as HomeViewController:
//                homeVC.tableView.setContentOffset(.zero, animated: true)
//            case let offerVC as OffersViewController:
//                offerVC.tableView.setContentOffset(.zero, animated: true)
//            case let settingsVC as SettingsViewController:
//                settingsVC.tableView.setContentOffset(.zero, animated: true)
//            default:
//                break
//            }
//
//        }

        return true
    }

}

