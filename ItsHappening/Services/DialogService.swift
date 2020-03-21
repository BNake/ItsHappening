//
//  DialogService.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/20/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit

protocol DialogServiceProtocol {
    func showActionSheet(title: String?, message: String?, actions: [DialogAction])
}

class DialogService: DialogServiceProtocol {
    func showActionSheet(title: String?, message: String?, actions: [DialogAction]) {
        // FIX ME: why its not depricated in cefco
        let topController = UIApplication.shared.keyWindow?.topMostViewController()
        let optionMenu = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        actions.map {UIAlertAction(title: $0.title, style: $0.style, action: $0.action)}.forEach {optionMenu.addAction($0)}
        optionMenu.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        topController?.present(optionMenu, animated: true, completion: nil)
    }
}

class DialogObject {
    let title: String?
    let message: String?
    let actions: [DialogAction]
    let style: Style
    
    public enum Style: Int {
        case actionSheet
        case alert
    }
    
    init(title: String? = nil, message: String? = nil, actions: [DialogAction], style: DialogObject.Style = .alert) {
        self.title = title
        self.message = message
        self.actions = actions
        self.style = style
    }
}


