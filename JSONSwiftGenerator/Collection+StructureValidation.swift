//
//  Collection+StructureValidation.swift
//  JSONSwiftGenerator
//
//  Created by Dan on 7/12/17.
//  Copyright © 2017 Bren. All rights reserved.
//

import Foundation

enum JSONCollectionType {
    case objectArray
    case hashArray
}

extension Collection where Element == Object {
    var jsonCollectionType: JSONCollectionType {
        guard let firstObject = self.first else { return .hashArray }
        
        for object in self.dropFirst() {
            for (key, value) in object {
                guard let firstObjectValue = firstObject[key] else { return .hashArray }
                
                if value is Object && !(firstObjectValue is Object) { return .hashArray }
                if value is [Any] && !(firstObjectValue is [Any]) { return .hashArray }
                if value is String && !(firstObjectValue is String) { return .hashArray }
                if value is Bool && !(firstObjectValue is Bool) { return .hashArray }
                if value is Double && !(firstObjectValue is Double) { return .hashArray }
            }
        }
        
        return .objectArray
    }
}
