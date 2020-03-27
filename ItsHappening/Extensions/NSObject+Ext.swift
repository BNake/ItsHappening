//
//  NSObject+Ext.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/20/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit

extension Mirror {

    func toDictionary() -> [String: AnyObject] {
        var dict = [String: AnyObject]()

        // Properties of this instance:
        for attr in self.children {
            if let propertyName = attr.label {
                dict[propertyName] = attr.value as AnyObject
            }
        }

        // Add properties of superclass:
        if let parent = self.superclassMirror {
            for (propertyName, value) in parent.toDictionary() {
                dict[propertyName] = value
            }
        }

        return dict
    }
}

extension NSObject {
    
    // MARK: compose dictionary out of Object, needed to store in firebase Database
    
    func toDict() -> [String : Any] {

        var dict: [String : Any] = [:]

        let propertyNames = Mirror(reflecting: self).toDictionary().compactMap { $0.key }
        let values = Mirror(reflecting: self).toDictionary().compactMap { $0.value }

        guard propertyNames.count != 0 else {return [:]}
        for n in 0...propertyNames.count - 1 {

            // go throu primatives
            if values[n] is NSString ||
                values[n] is Int ||
                values[n] is Double ||
                values[n] is Float ||
                values[n] is Bool {

                dict[propertyNames[n]] = values[n]

            }

            // got throu arrays
            else if let array = values[n] as? Array<Any> {
                var ar = [Any]()
                for item in array {
//                    if let i = item as? BasePojoModel {
//                        ar.append(i.toDict())
//                    } else {
//                        ar.append(item)
//                    }
                }
                dict[propertyNames[n]] = ar
            }

            // go throu dictionaries
            else if let d = values[n] as? NSDictionary {

                var innerDict: [String: Any] = [:]

                for item in d {
                    if item.value is String {
                        innerDict[item.key as! String] = item.value as! String
                    } else if let di = item.value as? NSDictionary {
                        innerDict[item.key as! String] = di
                    } else {
                        innerDict[item.key as! String] = (item.value as! NSObject).toDict()
                    }
                }
                dict[propertyNames[n]] = innerDict
            }

            // go throu objects
//            else if let object = values[n] as? BasePojoModel {
//                dict[propertyNames[n]] = object.toDict()
//            }
        }
        return dict
    }
}
