//
//  TutorialPageViewModel.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/21/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

class TutorialPageViewModel: ViewModelProtocol, ParameterProtocol {
    let mainImage: Observable<UIImage>?
    let title: Observable<String>?
    let text: Observable<String>?
    
    internal init(mainImage: Observable<UIImage>?,
                  title: Observable<String>?,
                  text: Observable<String>?) {
        self.mainImage = mainImage
        self.title = title
        self.text = text
    }
}

