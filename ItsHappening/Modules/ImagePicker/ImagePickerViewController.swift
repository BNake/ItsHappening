//
//  ImagePickerViewController.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/26/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit

class ImagePickerViewController: BaseImagePickerViewController<ImagePickerViewModel> {
    
    override func setupUI() {
        self.delegate = self
    }
    
    override func setupBinding() {
        
        viewModel.sourceDriver.asObservable().subscribe(onNext: { [weak self] (source) in
            self?.sourceType = source
        }).disposed(by: disposeBag)
        
    }
}

extension ImagePickerViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.viewModel.image.accept(image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ImagePickerViewController: UINavigationControllerDelegate {
    
}

