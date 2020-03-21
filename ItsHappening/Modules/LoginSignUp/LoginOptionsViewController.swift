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
    
    private let loginOrSignupButton: RoundedButton = {
        let button = RoundedButton()
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(ColorManager.systemBlue, for: .normal)
        button.backgroundColor = ColorManager.cefcoWhite
        return button
    }()
    
    private let continueButton: RoundedButton = {
        let button = RoundedButton()
        button.backgroundColor = .clear
        button.setTitleColor(ColorManager.cefcoWhite, for: .normal)
        button.backgroundColor = ColorManager.systemBlue
        button.layer.borderColor = ColorManager.label.cgColor
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
        
        view.add(continueButton, loginOrSignupButton)
        
        self.setViewControllers([tutorialPages[0]], direction: .forward, animated: true, completion: nil)
        
        continueButton.makeLayout {
            $0.centerX.equalToSuperView()
            $0.bottom.equalTo(view.sl.bottom).offset(size.height * 0.10)
            $0.leading.equalTo(view.sl.leading).offset(20)
            $0.trailing.equalTo(view.sl.trailing).offset(20)
            $0.height.equalTo(50)
        }
        
        loginOrSignupButton.makeLayout {
            $0.centerX.equalToSuperView()
            $0.bottom.equalTo(continueButton.sl.top).offset(size.height * 0.02)
            $0.leading.equalTo(view.sl.leading).offset(20)
            $0.trailing.equalTo(view.sl.trailing).offset(20)
            $0.height.equalTo(50)
        }
        
    }
    
    override func setupBinding() {
        viewModel?.continueTextDriver.drive(continueButton.rx.title()).disposed(by: disposeBag)
        viewModel?.signupTextDriver.drive(loginOrSignupButton.rx.title()).disposed(by: disposeBag)
        continueButton.rx.tap.bind(to: viewModel.continueCommand).disposed(by: disposeBag)
        loginOrSignupButton.rx.tap.bind(to: viewModel.loginCommand).disposed(by: disposeBag)
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


