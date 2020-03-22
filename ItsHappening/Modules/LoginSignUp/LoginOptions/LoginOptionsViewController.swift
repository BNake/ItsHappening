//
//  LoginOptionsViewController.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/21/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit

class LoginOptionsViewController: BasePageViewController<LoginOptionsViewModel> {
    var tutorialPages = [UIViewController]()
    
    private let signUpButton: RoundedButton = {
        let button = RoundedButton()
        button.setTitleColor(ColorManager.hBlue, for: .normal)
        button.backgroundColor = ColorManager.hWhite
        return button
    }()
    
    private let continueButton: RoundedButton = {
        let button = RoundedButton()
        button.backgroundColor = .clear
        button.setTitleColor(ColorManager.hWhite, for: .normal)
        button.backgroundColor = ColorManager.hBlue
        button.layer.borderColor = ColorManager.label.cgColor
        return button
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(ColorManager.hWhite, for: .normal)
        return button
    }()
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle,
                  navigationOrientation: UIPageViewController.NavigationOrientation,
                  options: [UIPageViewController.OptionsKey: Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: navigationOrientation, options: options)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        view.backgroundColor = ColorManager.systemBackground
        
        dataSource = self
        let size = UIScreen.main.bounds
        
        view.add(signUpButton, continueButton, loginButton)
        
        self.setViewControllers([tutorialPages[0]], direction: .forward, animated: true, completion: nil)
                
        signUpButton.makeLayout {
            $0.centerX.equalToSuperView()
            $0.bottom.equalTo(continueButton.sl.top).offset(size.height * 0.02)
            $0.leading.equalTo(view.sl.leading).offset(16)
            $0.trailing.equalTo(view.sl.trailing).offset(16)
            $0.height.equalTo(50)
        }
        
        continueButton.makeLayout {
            $0.centerX.equalToSuperView()
            $0.bottom.equalTo(loginButton.sl.top).offset(size.height * 0.01)
            $0.leading.equalTo(view.sl.leading).offset(16)
            $0.trailing.equalTo(view.sl.trailing).offset(16)
            $0.height.equalTo(50)
        }
        
        loginButton.makeLayout {
            $0.centerX.equalToSuperView()
            $0.bottom.equalTo(view.sl.bottom).offset(size.height * 0.05)
            $0.leading.equalTo(view.sl.leading).offset(16)
            $0.trailing.equalTo(view.sl.trailing).offset(16)
            $0.height.equalTo(50)
        }
        
    }
    
    override func setupBinding() {
        viewModel?.continueTextDriver.drive(continueButton.rx.title()).disposed(by: disposeBag)
        viewModel?.signupTextDriver.drive(signUpButton.rx.title()).disposed(by: disposeBag)
        viewModel?.loginTextDriver.drive(loginButton.rx.title()).disposed(by: disposeBag)
        continueButton.rx.tap.bind(to: viewModel.continueCommand).disposed(by: disposeBag)
        signUpButton.rx.tap.bind(to: viewModel.signUpCommand).disposed(by: disposeBag)
        loginButton.rx.tap.bind(to: viewModel.loginCommand).disposed(by: disposeBag)
    }
}

extension LoginOptionsViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let pageVC = viewController as? TutorialPageViewController else {
            return nil
        }
        
        guard let viewControllerIndex = tutorialPages.firstIndex(of: pageVC) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0, tutorialPages.count > previousIndex else {
            return nil
        }
        
        return tutorialPages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let pageVC = viewController as? TutorialPageViewController else {
            return nil
        }
        
        guard let viewControllerIndex = tutorialPages.firstIndex(of: pageVC) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        guard tutorialPages.count != nextIndex, tutorialPages.count > nextIndex else {
            return nil
        }
        
        return tutorialPages[nextIndex]
    }
    
}


