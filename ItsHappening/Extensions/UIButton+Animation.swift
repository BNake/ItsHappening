//
//  UIButton+Animation.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/3/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit
extension UIButton {
    func popAnimate() {
        let expandTransform:CGAffineTransform = CGAffineTransform(scaleX: 1.15, y: 1.15);
        
        UIView.transition(with: self,
                          duration:0.1,
                          options: UIView.AnimationOptions.transitionCrossDissolve,
                          animations: {
                            self.transform = expandTransform
        },
                          completion: {(finished: Bool) in
                            UIView.animate(
                                withDuration: 0.4,
                                delay: 0.0,
                                options:UIView.AnimationOptions.curveEaseOut,
                                animations: {
                                    self.transform = CGAffineTransform.inverted(expandTransform)()
                                    
                            }, completion: nil)
        })
    }
}
