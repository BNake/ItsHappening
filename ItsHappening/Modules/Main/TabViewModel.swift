//
//  TabViewModel.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/6/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import Foundation

class TabViewModel: BaseViewModel {
    let childType: BaseViewModel.Type
    let title: String
    let imageName: String
    let selectedImageName: String?
    let tag: Int
    
    init(for type: BaseViewModel.Type, title: String, imageName: String, selectedImageName: String? = nil, tag: Int) {
        self.childType = type
        self.title = title
        self.imageName = imageName
        self.selectedImageName = selectedImageName
        self.tag = tag
    }
}
