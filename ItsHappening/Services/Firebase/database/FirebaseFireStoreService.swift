//
//  FirebaseFireStoreService.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/26/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import FirebaseFirestoreSwift
import FirebaseFirestore
import RxSwift
import RxCocoa

class FirebaseFireStoreService<Type: FireStoreSaveable> {
    
    // MARK: firestore
    
    private let collectionName: String
    private let db: Firestore
    private var fireStoreListener: ListenerRegistration?
    
    // MARK: rx
    
    private let docs = ReplaySubject<([Type])>.create(bufferSize: 1)
    private var documents: Observable<([Type])> {
        docs.asObservable()
    }
    
    private let doc = ReplaySubject<(Type)>.create(bufferSize: 1)
    private var document: Observable<(Type)> {
        doc.asObservable()
    }
    
    // MARK: init
    
    init(collectionName: String) {
        self.collectionName = collectionName
        db = Firestore.firestore()
        debugPrint("init \(self)")
    }
    
    // MARK: deinit
    
    deinit {
        fireStoreListener?.remove()
        debugPrint("deint \(self) listener")
    }
    
    // MARK: add and edit
    
    public func set(document: Type, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        do {
            try db.collection(collectionName).document(document.id).setData(from: document) { error in
                guard let e = error else { success(); debugPrint("\(Type.self) inserted"); return; }
                failure(e)
            }
            
        } catch let e {
            debugPrint(e)
            failure(e)
        }
    }
    
    // MARK: delete
    
    public func delete(document: Type, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        db.collection(collectionName).document(document.id).delete { (error) in
            if let e = error {
                failure(e)
            } else {
                success()
                debugPrint("deleted. \(Type.self)");
            }
        }
    }
    
    // MARK: get
    
    public func getDocuments(success: @escaping ([Type]) -> Void, failure: @escaping (Error) -> Void) {
        db.collection(collectionName).getDocuments { (data, error) in
            
            if let e = error {
                failure(e)
            } else {
                guard let query = data else {
                    failure(DisplayError.init(code: .Not_Found, message: "Document Not Found"))
                    return
                }
                let types = self.composeTypes(from: query)
                success(types)
                debugPrint("received from firestore. [\(Type.self)] ");
            }
        }
    }
    
    public func getDocument(documnetId: String,
                            success: @escaping (Type) -> Void,
                            failure: @escaping (Error) -> Void) {
        
        db.collection(collectionName).document(documnetId).getDocument { (documentSnap, error) in
            if let e = error {
                failure(e)
            } else {
                guard let document = documentSnap else {
                    failure(DisplayError.init(code: .Not_Found, message: "Document Not Found"))
                    return
                }
                guard document.data() != nil else {
                    failure(DisplayError.init(code: .Not_Found, message: "Document Not Found"))
                    return
                }
                guard let type = self.composeType(from: document) else {
                    failure(DisplayError.init(code: .Parse_Error, message: "Can't parse document into \(Type.self)"))
                    return
                }
                success(type)
                debugPrint("received from firestore. \(Type.self)");
            }
        }

    }
    
    public func observeCollection() -> Observable<[Type]> {
        fireStoreListener = db.collection(collectionName).addSnapshotListener { [weak self] (querySnap, error) in
            guard let query = querySnap else { return }
            self?.publish(querySnap: query)
        }
        return documents
    }
    
    // MARK: publish
    
    private func publish(querySnap: QuerySnapshot) {
        
        let types = self.composeTypes(from: querySnap)
        docs.onNext(types)
        debugPrint("published. [\(Type.self)]");
        
    }
    
    private func publish(documentSnap: DocumentSnapshot) {
        
        guard let type = self.composeType(from: documentSnap) else { return }
        doc.onNext(type)
        debugPrint("published. \(Type.self)");
        
    }

    // MARK: compose
    
    private func composeTypes(from querySnap: QuerySnapshot) -> [Type] {
        
        var types: [Type] = []
        for doc in querySnap.documents {
            do {
                guard let object = try doc.data(as: Type.self) else { continue }
                types.append(object)
            } catch let e {
                debugPrint(e)
            }
        }
        
        return types
    }
    
    private func composeType(from documentSnap: DocumentSnapshot) -> Type? {
        
        do {
            let object = try documentSnap.data(as: Type.self)
            return object
        } catch let e {
            debugPrint(e)
            return nil
        }
        
    }
    
}
