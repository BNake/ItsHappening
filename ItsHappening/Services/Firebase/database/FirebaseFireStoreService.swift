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
import InstantSearchClient

class FirebaseFireStoreService<Type: FireStoreSaveable> {
    
    // MARK: firestore
    
    private let collectionName: String
    private let db: Firestore
    private var fireStoreListener: ListenerRegistration?
    private let disposeBag = DisposeBag()
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
        debugPrint("init ---- \(self) ----")
    }
    
    // MARK: deinit
    
    deinit {
        fireStoreListener?.remove()
        debugPrint("deint ---- \(self) ---- listener")
    }
    
    // MARK: add and edit
    
    public func set(document: Type, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        do {
            try db.collection(collectionName).document(document.id).setData(from: document) { error in
                guard let e = error else { success(); debugPrint("---- \(Type.self) ---- added"); return; }
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
                    failure(DisplayError.init(code: .Not_Found, message: "Documents Not Found"))
                    return
                }
                let types = self.composeTypes(from: query)
                success(types)
                debugPrint("received from firestore ---- [\(Type.self)] ----");
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
                    failure(DisplayError.init(code: .Parse_Error, message: "Can't parse document ---- \(Type.self) ----"))
                    return
                }
                success(type)
                debugPrint("received from firestore ---- \(Type.self) ----");
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
    
    // query
    
    public func search(queryString: String,
                       attributesToRetrieve: [String],
                       maxCount: UInt,
                       success: @escaping ([Type]) -> Void,
                       failure: @escaping (Error) -> Void) {
        
        // guard let bundle = Bundle.main.bundleIdentifier else { return }
        let searchClient = Client(appID: "589GLHB5XN", apiKey: "550af8e812f7b68cba827f095584453c")
        let indexName = "\(collectionName)_dev"
        let collectionIndex : Index = searchClient.index(withName: indexName)
        
        let query = Query()
        query.hitsPerPage = maxCount
        query.attributesToRetrieve = attributesToRetrieve
        
        query.query = queryString
        collectionIndex.search(query) { (content, error) in
            guard let content = content else {
                if let error = error {
                    failure(error)
                }
                success([])
                return
            }
            
            guard let hits = content["hits"] as? [[String: AnyObject]] else {
                success([])
                return
            }
            
            var types:[Type] = []
            hits.forEach({ (record) in
                
                let user = Type(dict: record)
                types.append(user)
            })
            
            success(types)
        }
        
    }
    
    public func queryDocuments(queries: [FirestoryQuery],
                               success: @escaping ([Type]) -> Void,
                               failure: @escaping (Error) -> Void) {
        
        var observables: [BehaviorRelay<[Type]>] = []
        for query in queries {
            
            let subject = BehaviorRelay<[Type]>(value: [])
            observables.append(subject)
            
            switch query.queryOperator {
            case .isEqualTo:
                isEqualTo(query: query, success: { (types) in
                    subject.accept(types)
                }, failure: failure)
            case .isLessThan:
                isLessThan(query: query, success: { (types) in
                    subject.accept(types)
                }, failure: failure)
            case .isLessThanOrEqualTo:
                isLessThanOrEqualTo(query: query, success: { (types) in
                    subject.accept(types)
                }, failure: failure)
            case .isGreaterThan:
                isGreaterThan(query: query, success: { (types) in
                    subject.accept(types)
                }, failure: failure)
            case .isGreaterThanOrEqualTo:
                isGreaterThanOrEqualTo(query: query, success: { (types) in
                    subject.accept(types)
                }, failure: failure)
            }
        }
        
        Observable.combineLatest(observables).subscribe(onNext: { (arrayOfArrays) in
            var combined: [Type] = []
            arrayOfArrays.forEach { (array) in
                combined.append(contentsOf: array)
            }
            var dict = [String: Type]()
            _ = combined.map { (type) -> Void in
                dict[type.id] = type
            }
            var unique = [Type]()
            for item in dict {
                unique.append(item.value)
            }
            success(unique)
        }).disposed(by: disposeBag)
        
    }
    
    private func isEqualTo(query: FirestoryQuery,
                           success: @escaping ([Type]) -> Void,
                           failure: @escaping (Error) -> Void) {
        
        db.collection(collectionName)
            .whereField(query.propertyName, isEqualTo: query.value).limit(to: query.limit)
            .getDocuments { (data, error) in
                if let e = error {
                    failure(e)
                } else {
                    guard let query = data else {
                        failure(DisplayError.init(code: .Not_Found, message: "Documents Not Found"))
                        return
                    }
                    let types = self.composeTypes(from: query)
                    success(types)
                    debugPrint("received from firestore ---- [\(Type.self)] ----");
                }
        }
    }
    
    private func isLessThan(query: FirestoryQuery,
                            success: @escaping ([Type]) -> Void,
                            failure: @escaping (Error) -> Void) {
        db.collection(collectionName)
            .whereField(query.propertyName, isLessThan: query.value).limit(to: query.limit)
            .getDocuments { (data, error) in
                if let e = error {
                    failure(e)
                } else {
                    guard let query = data else {
                        failure(DisplayError.init(code: .Not_Found, message: "Documents Not Found"))
                        return
                    }
                    let types = self.composeTypes(from: query)
                    success(types)
                    debugPrint("received from firestore ---- [\(Type.self)] ----");
                }
        }
    }
    
    private func isLessThanOrEqualTo(query: FirestoryQuery,
                                     success: @escaping ([Type]) -> Void,
                                     failure: @escaping (Error) -> Void) {
        db.collection(collectionName)
            .whereField(query.propertyName, isLessThanOrEqualTo: query.value).limit(to: query.limit)
            .getDocuments { (data, error) in
                if let e = error {
                    failure(e)
                } else {
                    guard let query = data else {
                        failure(DisplayError.init(code: .Not_Found, message: "Documents Not Found"))
                        return
                    }
                    let types = self.composeTypes(from: query)
                    success(types)
                    debugPrint("received from firestore ---- [\(Type.self)] ----");
                }
        }
    }
    
    private func isGreaterThan(query: FirestoryQuery,
                               success: @escaping ([Type]) -> Void,
                               failure: @escaping (Error) -> Void) {
        db.collection(collectionName)
            .whereField(query.propertyName, isGreaterThan: query.value).limit(to: query.limit)
            .getDocuments { (data, error) in
                if let e = error {
                    failure(e)
                } else {
                    guard let query = data else {
                        failure(DisplayError.init(code: .Not_Found, message: "Documents Not Found"))
                        return
                    }
                    let types = self.composeTypes(from: query)
                    success(types)
                    debugPrint("received from firestore ---- [\(Type.self)] ----");
                }
        }
    }
    
    private func isGreaterThanOrEqualTo(query: FirestoryQuery,
                                        success: @escaping ([Type]) -> Void,
                                        failure: @escaping (Error) -> Void) {
        db.collection(collectionName)
            .whereField(query.propertyName, isGreaterThanOrEqualTo: query.value).limit(to: query.limit)
            .getDocuments { (data, error) in
                if let e = error {
                    failure(e)
                } else {
                    guard let query = data else {
                        failure(DisplayError.init(code: .Not_Found, message: "Documents Not Found"))
                        return
                    }
                    let types = self.composeTypes(from: query)
                    success(types)
                    debugPrint("received from firestore ---- [\(Type.self)] ----");
                }
        }
    }
    
    // MARK: publish
    
    private func publish(querySnap: QuerySnapshot) {
        
        let types = self.composeTypes(from: querySnap)
        docs.onNext(types)
        debugPrint("published ---- [\(Type.self)] ----");
        
    }
    
    private func publish(documentSnap: DocumentSnapshot) {
        
        guard let type = self.composeType(from: documentSnap) else { return }
        doc.onNext(type)
        debugPrint("published ---- \(Type.self) ----");
        
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
