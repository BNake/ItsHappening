//
//  VerifyEmailViewController.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/29/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit
import Lottie

class VerifyEmailViewController: BaseViewController<VerifyEmailViewModel> {
    
    private let animationView: AnimationView = {
        let animationView = AnimationView(name: "emailSent")
        animationView.contentMode = .scaleAspectFit
        return animationView
    }()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textColor = ColorManager.hBlue
        view.textAlignment = .center
        return view
    }()
    
    private let resendEmailButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(ColorManager.hBlue, for: .normal)
        return button
    }()
    
    override func setupUI() {
        
        self.forceSetupCloseButton()
        view.backgroundColor = ColorManager.systemBackground
        view.add(animationView, titleLabel, resendEmailButton)
        
        let size = UIScreen.main.bounds
        animationView.makeLayout {
            $0.centerX.equalToSuperView()
            $0.centerY.equalToSuperView().offset(size.height * -0.20)
            $0.height.equalTo(size.height * 0.25)
            $0.width.equalTo(size.width * 0.40)
        }
        animationView.loopMode = .loop
        animationView.play(fromProgress: 0, toProgress: 1) { (_) in }
        
        titleLabel.makeLayout {
            $0.centerX.equalToSuperView()
            $0.top.equalTo(animationView.sl.bottom).offset(size.height * 0.1)
            $0.left.equalToSuperView().offset(10)
            $0.right.equalToSuperView().offset(10)
        }
        
        resendEmailButton.makeLayout {
            $0.centerX.equalToSuperView()
            $0.top.equalTo(titleLabel.sl.bottom).offset(size.height * 0.1)
            $0.leading.equalToSuperView().offset(20)
            $0.trailing.equalToSuperView().offset(20)
            $0.height.equalTo(40)
        }
    }
    
    override func setupBinding() {
        viewModel.verificationListenerDriver.drive(titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.didNtgetEmailDriver.drive(resendEmailButton.rx.title()).disposed(by: disposeBag)
        
        resendEmailButton.rx.tap.bind(to: viewModel.didntGetEmailCommand).disposed(by: disposeBag)
        closeBarButton.rx.tap.bind(to: viewModel.closeAction).disposed(by: disposeBag)

    }
}
