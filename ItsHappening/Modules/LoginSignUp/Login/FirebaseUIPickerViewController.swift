//
//  FirebaseUIPickerViewController.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/28/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit
import FirebaseUI

public class FirebaseUIPickerViewController: FUIAuthPickerViewController {
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Locking for Something new?"
        view.textAlignment = .center
        view.textColor = ColorManager.hBlue
        view.numberOfLines = 2
        view.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        return view
    }()
    
    private let textLabel: UILabel = {
        let view = UILabel()
        view.text = "Attend the newest and latest happenings in your side of town!"
        view.numberOfLines = 0
        view.textColor = ColorManager.hBlue
        view.textAlignment = .center
        return view
    }()
    
    private let image: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "logo")!
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.add(containerView)
        self.containerView.add(image, titleLabel, textLabel)
        
        let size = UIScreen.main.bounds
        
        containerView.makeLayout {
            $0.top.equalToSuperView()
            $0.leading.equalToSuperView()
            $0.trailing.equalToSuperView()
            if let buttonsContainer = self.view.subviews.first?.subviews.first {
                $0.bottom.equalTo(buttonsContainer.sl.top)
            } else {
                $0.height.equalTo(size.height * 0.5)
            }
        }
        
        image.makeLayout {
            $0.centerX.equalToSuperView()
            $0.top.equalToSuperView().offset(size.height * 0.2)
            $0.height.equalTo(50)
            $0.width.equalTo(50)
        }
        
        titleLabel.makeLayout {
            $0.centerX.equalToSuperView()
            $0.top.equalTo(image.sl.bottom).offset(size.height * 0.08)
            $0.left.equalToSuperView().offset(10)
            $0.right.equalToSuperView().offset(10)
        }
        
        textLabel.makeLayout {
            $0.top.equalTo(titleLabel.sl.bottom).offset(11)
            $0.left.equalTo(view.sl.left).offset(50)
            $0.right.equalTo(view.sl.right).offset(50)
        }
        
    }
}
