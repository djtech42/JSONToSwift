//
//  Array+StructureValidation.swift
//  JSONSwiftGenerator
//
//  Created by Dan on 7/12/17.
//  Copyright © 2017 Bren. All rights reserved.
//

import Foundation

extension Array where Element == [String : Any] {
    func validateStructure() -> Bool {
        let firstObject = self[0]
        
        for object in self.dropFirst() {
            for (key, value) in object {
                guard let firstObjectValue = firstObject[key] else { return false }
                
                if value is [String: Any] && !(firstObjectValue is [String: Any]) { return false }
                if value is Array<Any> && !(firstObjectValue is Array<Any>) { return false }
                if value is String && (firstObjectValue is String) { return false }
                if value is Bool && !(firstObjectValue is Bool) { return false }
                if value is Double && !(firstObjectValue is Double) { return false }
            }
        }
        
        return true
    }
}
