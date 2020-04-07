//
//  MainRouter.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/6/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit

protocol MainRouterProtocol: RouterProtocol {
    func createTab(for: TabViewModel)
    func updateTab(for: TabViewModel)
    func show(index: Int)
}

class MainRouter: BaseRouter, MainRouterProtocol {
    
    
    func updateTab(for viewModel: TabViewModel) {
        let navigationVC: UITabBarController = navigationService.navigationController()
        if let targetVC = navigationVC.viewControllers?.first(where: {$0.tabBarItem.tag == viewModel.tag}) {
            let item = UITabBarItem(title: viewModel.title, image: UIImage(named: viewModel.imageName), tag: viewModel.tag)
            targetVC.tabBarItem = item
            if let selectedImageName = viewModel.selectedImageName {
                item.selectedImage = UIImage(named: selectedImageName)
            }
        }
    }
        
    func createTab(for tabViewModel: TabViewModel) {
        let navigationController = HappeningNavigationController()
        let childService: LinearNavigationService = navigationService.createChildNavigation(navigationController: navigationController)
        let controller = childService.navigationController()
        let item = UITabBarItem(title: tabViewModel.title, image: UIImage(named: tabViewModel.imageName), tag: tabViewModel.tag)
        controller.tabBarItem = item
        if let selectedImageName = tabViewModel.selectedImageName {
            item.selectedImage = UIImage(named: selectedImageName)
        }
        childService.push(viewModel: tabViewModel.childType, with: nil)
    }
    
    func show(index: Int) {
       let navigationVC: UITabBarController = navigationService.navigationController()
       navigationVC.selectedIndex = index
    }
    
}
