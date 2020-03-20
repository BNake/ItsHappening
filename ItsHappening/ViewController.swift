//
//  ViewController.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/19/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let eventsTable = FirebaseDatabaseService<Event>(tableName: "Events")
        
        eventsTable.observe()
            .subscribe(onNext: { (event, action) in
                
                switch action {
                case .added:
                    self.events.append(event)
                    print(action, self.events.count)
                case .removed:
                    self.events.removeAll { $0.id == event.id }
                    print(action, self.events.count)
                case .changed:
                    break
                }
                
            }).disposed(by: disposeBag)
        
        
//        for i in 0...10 {
//            let coordinate: Coordinate = Coordinate(latitude: 32.877, longitude: 92.432)
//            let address = Address(streetAddress: "207 Kensingron Trace",
//                                  city: "Canton",
//                                  state: "GA",
//                                  zipCode: "30115",
//                                  coordinate: coordinate)
//            let event = Event(ownerID: "453434", address: address)
//            event.imageURL = "some url"
//            eventsTable.insertOrUpdate(row: event, success: {}, failure: { _ in})
//        }
        
        
    }


}

