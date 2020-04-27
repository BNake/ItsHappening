//
//  FirebaseStorageService.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/26/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import FirebaseStorage

class FirebaseStorageService {
    
    static let sharedInstance = FirebaseStorageService()
    private var storageRef: StorageReference = StorageReference()
    
    func saveImageToStorage(image: UIImage,
                                   storagePath: String,
                                   success: @escaping(String)->Void,
                                   failure: @escaping(Error)->Void) {
        
        var data = Data()
        data = image.jpegData( compressionQuality: 0.8 )!
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        self.storageRef = storageRef.child(storagePath)
        storageRef.putData(data, metadata: metaData) { (mtData ,error) in
            if let error = error {
                failure(error)
            } else {
                
                self.storageRef.downloadURL(completion: { (url, error) in
                    guard let url = url else { failure(error!); return }
                    success(url.absoluteString)
                })
            }
            
        }
    }
}
