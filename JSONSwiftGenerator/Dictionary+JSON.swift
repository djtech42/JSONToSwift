//
//  Dictionary+JSON.swift
//  JSONSwiftGenerator
//
//  Created by Dan Turner on 3/3/17.
//  Copyright © 2017 Bren. All rights reserved.
//

import Foundation

extension Dictionary {
    func items(ofJSONType type: JSONType?) -> [(key: Key, value: Value)] {
        switch type {
        // null
        case .none: return filter { !($0.value is Array<Any>) && !($0.value is Dictionary<String, Any>) && !($0.value is String) && !($0.value is Double) && !($0.value is Bool) }
            
        case .some(let existingType):
            switch existingType {
            case .string: return filter { $0.value is String }
            case .number: return filter { $0.value is Double }
            case .boolean: return filter({ !($0.value is Double)  }).filter { $0.value is Bool }
                
            case .array: return filter { $0.value is Array<Any> }
            case .arrayOf(let type):
                return
                    filter { $0.value is Array<Any> }
                    .reduce([:], { (dictionary, entry) -> [Key:Value] in
                        var mutableDictionaryCopy = dictionary
                        mutableDictionaryCopy[entry.key] = entry.value
                        return mutableDictionaryCopy
                    }).items(ofJSONType: type)
            case .object:
                return filter { $0.value is Dictionary<String, Any> }
            }
        }
    }
    
    var equatableValues: [(key: Key, value: Value)] {
        return filter { $0.value is Dictionary<String, Any> || $0.value is String || $0.value is Double || $0.value is Bool }
    }
}
