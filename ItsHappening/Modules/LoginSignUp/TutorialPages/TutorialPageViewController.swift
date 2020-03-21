//
//  TutorialPageViewController.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/21/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TutorialPageViewController: BaseViewController<TutorialPageViewModel> {
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = ColorManager.cefcoWhite
        view.numberOfLines = 2
        view.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        return view
    }()
    
    private let textLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textColor = ColorManager.cefcoWhite
        view.textAlignment = .center
        return view
    }()
    
    private let image: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func setupUI() {
        view.add(image, titleLabel, textLabel)
        
        image.makeLayout {
            $0.top.equalToSuperView()
            $0.bottom.equalToSuperView()
            $0.left.equalToSuperView()
            $0.right.equalToSuperView()
        }
        titleLabel.makeLayout {
            $0.centerY.equalToSuperView().offset(-150)
            $0.centerX.equalToSuperView()
            $0.left.equalToSuperView().offset(10)
            $0.right.equalToSuperView().offset(10)
        }
        textLabel.makeLayout {
            $0.top.equalTo(titleLabel.sl.bottom).offset(11)
            $0.left.equalTo(view.sl.left).offset(50)
            $0.right.equalTo(view.sl.right).offset(50)
        }
    }
    
    override func setupBinding() {
        viewModel?.title?.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
        viewModel?.text?.bind(to: textLabel.rx.text).disposed(by: disposeBag)
        viewModel?.mainImage?.bind(to: image.rx.image).disposed(by: disposeBag)
    }
}


