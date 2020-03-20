//
//  FirebaseDatabaseService.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/20/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import FirebaseDatabase
import FirebaseFirestore
import RxSwift
import RxCocoa

enum FirebaseEventType {
    case added
    case removed
    case changed
}

class FirebaseDatabaseService<Type: BasePojoModel> {
    
    private let tableName: DatabaseReference?
    
    // MARK: - Rx
    private let _rows = ReplaySubject<(Type, FirebaseEventType)>.create(bufferSize: 1)
    private var rows: Observable<(Type, FirebaseEventType)> {
        _rows.asObservable()
    }
    // let storageRef: StorageReference?
    
    init(tableName: String) {
        self.tableName = Database.database().reference(withPath: tableName)
        // self.storageRef = StorageReference()
    }
    
    // MARK: provides observer for each item
    public func observe() -> Observable<(Type, FirebaseEventType)> {
        
        tableName?.observe(.childAdded, with: { (data) in
            self.publish(dataSnap: data, eventType: .added)
        })
        tableName?.observe(.childChanged, with: { (data) in
            self.publish(dataSnap: data, eventType: .changed)
        })
        tableName?.observe(.childRemoved, with: { (data) in
            self.publish(dataSnap: data, eventType: .removed)
        })
        return rows
    }
    
    // MARK: publish
    private func publish(dataSnap: DataSnapshot, eventType: FirebaseEventType) {
        let item = self.composeType(from: dataSnap)
        if let i = item {
            self._rows.onNext((i, eventType))
        }
    }
    
    private func composeType(from dataSnap: DataSnapshot) -> Type? {
        guard var dict = dataSnap.value as? [String: Any] else { return nil }
        dict["id"] = dataSnap.key
        let item = Type(dict: dict)
        return item
    }
    
    func insert( row: BasePojoModel,
                 success: @escaping()->Void,
                 failure: @escaping(Error)->Void) {
        
        tableName?.child(row.id).setValue(row.toDict()) { (error:Error?, ref:DatabaseReference) in
            if let error = error {
                failure(error)
            } else {
                success()
            }
        }
    }
    
    func update(path: String,
                item: Any,
                success: @escaping()->Void,
                failure: @escaping(Error)->Void) {
        
        
        tableName?.child(path).setValue(item){
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                failure(error)
            } else {
                success()
            }
        }
    }
    
    func delete( object: Type, success: @escaping()->Void, failure: @escaping(Error)->Void) {
        tableName?.child(object.id).removeValue(){
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                failure(error)
            } else {
                success()
            }
        }
    }
    
    func delete(path: String, success: @escaping()->Void, failure: @escaping(Error)->Void) {
        tableName?.child(path).removeValue(){
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                failure(error)
            } else {
                success()
            }
        }
    }
        
    func removeAllObservers() {
        tableName?.removeAllObservers()
    }
    
}

