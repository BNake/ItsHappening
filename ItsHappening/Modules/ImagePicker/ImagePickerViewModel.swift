//
//  ImagePickerViewModel.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/26/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import RxCocoa
import RxSwift

struct ImagePickerParams: ParameterProtocol {
    let source: UIImagePickerController.SourceType
    let imageSelected: (UIImage) -> Void
}

class ImagePickerViewModel: BaseViewModel {
    
    let router: ImagePickerRouter
    private(set) var params: ImagePickerParams?
    
    // MARK: out
    
    private let source = BehaviorRelay<UIImagePickerController.SourceType>(value: .photoLibrary)
    var sourceDriver: Driver<UIImagePickerController.SourceType> {
        return source.asDriver()
    }
    
    let image = PublishRelay<UIImage>()
    
    init(router: ImagePickerRouter) {
        self.router = router
        super.init()
        
        image.subscribe(onNext: { [weak self] image in
            self?.params?.imageSelected(image)
        }).disposed(by: disposeBag)
    }
    
    override func prepare(with: ParameterProtocol?) {
        self.params = with as? ImagePickerParams
        setUp()
    }
    
    private func setUp() {
        guard let params = self.params else { return }
        
        source.accept(params.source)
    }
}

