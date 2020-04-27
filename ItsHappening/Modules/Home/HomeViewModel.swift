//
//  HomeViewModel.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/4/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import RxCocoa
import RxSwift

class HomeViewModel: BaseViewModel {
    
    private var usersDisposedBag = DisposeBag()

    let router: HomeRouter
    private let sectionViewModels = BehaviorRelay<[SectionViewModel]>(value: [])
    var sectionViewModelsDriver: Driver<[SectionViewModel]> {
        return sectionViewModels.asDriver(onErrorJustReturn: [])
    }

    init(router: HomeRouter) {
        self.router = router
        super.init()
        setupData()
    }
    
    private func setupData() {
        let usersTable = FirebaseFireStoreService<HappeningUser>(collectionName: "Users")

        usersTable.getDocuments(success: { (users) in

            let rows = self.makeRows(from: users)
            var sections: [SectionViewModel] = []

            let mainSection = SectionViewModel(viewModels: rows)
            sections.append(mainSection)
            self.sectionViewModels.accept(sections)

        }) { (error) in

        }
    }

    // MARK: Binding

    private func binding() {
        
    }
    
    
    private func makeRows(from users: [HappeningUser]) -> [SimpleTextViewModel] {
        var rows: [SimpleTextViewModel] = []
        usersDisposedBag = DisposeBag()
        let c = UIAlertAction(title: "Cancel", style: .cancel){ UIAlertAction in
            
        }
        for user in users {
            let row = SimpleTextViewModel(title: user.firstName ?? "") { [weak self] in
                
                let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] UIAlertAction in
                    
                    if(UIImagePickerController .isSourceTypeAvailable(.camera)){
                        
                        self?.router.showImagePicker(imagePickerParams: ImagePickerParams(source: .camera, imageSelected: { image in
                            var a = 0
                        }))
                    } else {
                        
                        self?.router.showAlert(alertParams: AlertParams(title: "Opps",
                                                                        message: "No camera found on this device.",
                                                                        style: .alert,
                                                                        actionList: [c]))
                    }
                    
                    
                }
                let gallaryAction = UIAlertAction(title: "Gallary", style: .default){ UIAlertAction in
                    self?.router.showImagePicker(imagePickerParams: ImagePickerParams(source: .photoLibrary, imageSelected: { image in
                        FirebaseStorageService.sharedInstance.saveImageToStorage(image: image, storagePath: "gogogo", success: { (url) in
                            debugPrint(url)
                        }) { (error) in
                            
                        }
                    }))
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){ UIAlertAction in
                    
                }
                self?.router.showAlert(alertParams: AlertParams(title: user.firstName ?? "",
                                                                message: "message",
                                                                style: .alert,
                                                                actionList: [cameraAction,
                                                                             gallaryAction,
                                                                             cancelAction]))
            }
            rows.append(row)
        }
        return rows
    }
    
}
