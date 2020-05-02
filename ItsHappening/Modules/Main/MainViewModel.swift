//
//  MainViewModel.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/6/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import Foundation

import Foundation

class MainViewModel: BaseViewModel {
    
    private var router: MainRouterProtocol?
    private var tabViewModels: [TabViewModel] = []
    
    init(router: MainRouterProtocol) {
        self.router = router
        super.init()
        setupViewModels()
        createTabs()
    }
    
    func setupViewModels() {
        tabViewModels.removeAll()
        tabViewModels.append(TabViewModel(for: ContactViewModel.self,
                                          title: "Contact",
                                          imageName: "home_tab",
                                          selectedImageName: "home_tab",
                                          tag: 3))
        tabViewModels.append(TabViewModel(for: ProfileViewModel.self,
                                          title: "Home",
                                          imageName: "home_tab",
                                          selectedImageName: "home_tab",
                                          tag: 3))
        tabViewModels.append(TabViewModel(for: ContactViewModel.self,
                                          title: "Contact",
                                          imageName: "home_tab",
                                          selectedImageName: "home_tab",
                                          tag: 3))
        tabViewModels.append(TabViewModel(for: HomeViewModel.self,
                                          title: "Home",
                                          imageName: "home_tab",
                                          selectedImageName: "home_tab",
                                          tag: 3))
        tabViewModels.append(TabViewModel(for: HomeViewModel.self,
                                          title: "Home",
                                          imageName: "home_tab",
                                          selectedImageName: "home_tab",
                                          tag: 3))
        
        // Open any tabs
//        HomeManager.sharedInstance.openMainTabItem.subscribe(onNext: {[weak self] item in
//            if let item = item {
//                self?.show(item)
//            }
//        }).disposed(by: disposeBag)
        
        self.router?.show(index: 2)
        
    }
    
    private func createTabs() {
        tabViewModels.forEach { [weak self] in self?.router?.createTab(for: $0) }
    }
    
}
