//
//  JSONCollection.swift
//  JSONSwiftGenerator
//
//  Created by Brenden Konnagan on 2/28/17.
//  Copyright © 2017 Bren. All rights reserved.
//

import Foundation

struct JSONCollection {
    fileprivate var contents: Object = [:]
    var originalKeys: Object = [:]
    var swiftToOriginalKeyMapping: [String : String] = [:]
    var containsBadKey: Bool = false
    
    init(with key: String, element: Any) {
        if !key.isFormattedForSwiftPropertyName {
            containsBadKey = true
        }
        originalKeys[key] = element
        
        let fixedKey = key.formattedForSwiftPropertyName
        swiftToOriginalKeyMapping[fixedKey] = key
        
        add(element, for: fixedKey)
    }
    
    init<S: Sequence>(_ sequence: S) where S.Iterator.Element == (key: String, value: Any) {
        for (key, value) in sequence {
            if !key.isFormattedForSwiftPropertyName {
                containsBadKey = true
            }
            originalKeys[key] = value
            
            let fixedKey = key.formattedForSwiftPropertyName
            swiftToOriginalKeyMapping[fixedKey] = key
            
            add(value, for: fixedKey)
        }
    }
    
    init<S: Sequence>(_ sequence: S) {
        if let objectArray = sequence as? [Object] {
            add(objectArray, for: "objects")
        }
        else if let array = sequence as? [[Any]] {
            add(array, for: "arrays")
        }
        else {
            add(sequence, for: "values")
        }
    }
}

extension JSONCollection {
    mutating func add(_ element: Any, for key: String) {
        if !contents.contains(where: { $0.key == key }) {
            contents[key] = element
        }
    }
    
    mutating func remove(_ key: String) {
        precondition(contents.contains(where: { $0.key == key }), "Missing node with specified key: \(key)")
        contents.removeValue(forKey: key)
    }
}

extension JSONCollection: CustomStringConvertible {
    var description: String {
        return String(describing: contents)
    }
}

extension JSONCollection: ExpressibleByDictionaryLiteral {
    init(dictionaryLiteral elements: (String, Any)...) {
        self.init(elements.map { (key: $0.0, value: $0.1) })
    }
}

extension JSONCollection: Sequence {
    typealias Iterator = AnyIterator<(value: Any, key: String)>
    
    func makeIterator() -> Iterator {
        var existingIterator = contents.makeIterator()
        return AnyIterator {
            existingIterator.next()
        }
    }
}

extension JSONCollection: Collection {
    typealias Index = DictionaryIndex<String, Any>
    
    var startIndex: Index {
        return contents.startIndex
    }
    
    var endIndex: Index {
        return contents.endIndex
    }
    
    subscript (position: Index) -> Iterator.Element {
        precondition(indices.contains(position), "Index out of bounds")
        let dictionaryElement = contents[position]
        return (key: dictionaryElement.key, value: dictionaryElement.value)
    }
    
    func index(after otherIndex: Index) -> Index {
        return contents.index(after: otherIndex)
    }
}

extension JSONCollection {
    var equatableItems: [(key: String, value: Any)] {
        return contents.filter { $0.value is Object || $0.value is String || $0.value is Double || $0.value is Bool || $0.value is [Bool] || $0.value is [String] || $0.value is [Double] || $0.value is [Object] }
    }
    
    var arrayItems: [(key: String, value: Any)] {
        return contents.filter { $0.value is [Any] }
    }
    
    var objectArrayItems: [(key: String, value: Any)] {
        return contents.filter {
            guard let array = $0.value as? [Object] else { return false }
            
            return array.jsonCollectionType == .objectArray
        }
    }
    
    var hashArrayItems: [(key: String, value: Any)] {
        return contents.filter {
            guard let array = $0.value as? [Hash] else { return false }
            
            return array.jsonCollectionType == .hashArray
        }
    }
    
    var objectItems: [(key: String, value: Any)] {
        return contents.filter { $0.value is Object }
    }
    
    var stringItems: [(key: String, value: Any)] {
        return contents.filter { $0.value is String }
    }
    
    var numberItems: [(key: String, value: Any)] {
        return contents.filter { $0.value is Double }
    }
    
    var boolItems: [(key: String, value: Any)] {
        let mutableCopy = contents.filter({ !($0.value is Double) })
        return mutableCopy.filter { $0.value is Bool }
    }
    
    var nullItems: [(key: String, value: Any)] {
        return contents.filter { !($0.value is [Any]) && !($0.value is Object) && !($0.value is String) && !($0.value is Double) && !($0.value is Bool) }
    }
}

extension JSONCollection {
    var arrayItemPropertyStrings: [String] {
        var allArrayPropertyStrings: [String] = []
        
        allArrayPropertyStrings += arrayItems.filter({ !($0.value is [Double]) }).filter { $0.value is [Bool] }.map { SwiftLanguage.propertyString(name: $0.key, withType: "[Bool]") }
        allArrayPropertyStrings += arrayItems.filter { $0.value is [Double] }.map { SwiftLanguage.propertyString(name: $0.key, withType: "[Double]") }
        allArrayPropertyStrings += arrayItems.filter { $0.value is [String] }.map { SwiftLanguage.propertyString(name: $0.key, withType: "[String]") }
        allArrayPropertyStrings += objectArrayItems.map { SwiftLanguage.propertyString(name: $0.key, withType: "[\($0.key.madeSingleFromPlural.formattedForSwiftTypeName)]") }
        allArrayPropertyStrings += hashArrayItems.map { SwiftLanguage.propertyString(name: $0.key, withType: "[String : Any]") }
        allArrayPropertyStrings += arrayItems.filter { !($0.value is [String]) && !($0.value is [Double]) && !($0.value is [Bool]) && !($0.value is [Object]) }.map { SwiftLanguage.propertyString(name: $0.key, withType: "[Any]") }
        
        return allArrayPropertyStrings
    }
    
    var arrayItemInitStrings: [String] {
        var arrayInitStrings: [String] = []
        
        arrayInitStrings += arrayItems.filter({ !($0.value is [Double]) }).filter { $0.value is [Bool] }.map { SwiftLanguage.initializerWithDefaultValueCast(name: $0.key, dictionaryName: swiftToOriginalKeyMapping[$0.key]!, toType: "[Bool]", defaultValueString: "[]") }
        arrayInitStrings += arrayItems.filter { $0.value is [Double] }.map { SwiftLanguage.initializerWithDefaultValueCast(name: $0.key, dictionaryName: swiftToOriginalKeyMapping[$0.key]!, toType: "[Double]", defaultValueString: "[]") }
        arrayInitStrings += arrayItems.filter { $0.value is [String] }.map { SwiftLanguage.initializerWithDefaultValueCast(name: $0.key, dictionaryName: swiftToOriginalKeyMapping[$0.key]!, toType: "[String]", defaultValueString: "[]") }
        arrayInitStrings += hashArrayItems.map { SwiftLanguage.initializerWithDefaultValueCast(name: $0.key, dictionaryName: swiftToOriginalKeyMapping[$0.key]!, toType: "[String : Any]", defaultValueString: "[:]") }
        arrayInitStrings += arrayItems.filter { !($0.value is [String]) && !($0.value is [Double]) && !($0.value is [Bool]) && !($0.value is [Object]) }.map { SwiftLanguage.initializerWithDefaultValueCast(name: $0.key, dictionaryName: swiftToOriginalKeyMapping[$0.key]!, toType: "[Any]", defaultValueString: "[]") }
        
        return arrayInitStrings
    }
    
    var objectArrayInitStrings: [String] {
        return objectArrayItems.map { "let \($0.key.madeSingleFromPlural)ObjectArray = dictionary[\"\($0.key)\"] as? [[String : Any]] ?? [[:]]\n\t\tself.\($0.key) = \($0.key.madeSingleFromPlural)ObjectArray.flatMap(\($0.key.madeSingleFromPlural.formattedForSwiftTypeName).init)" }
    }
    
    var objectArrayItemStructNames: [String] {
        return objectArrayItems.map { $0.key.madeSingleFromPlural.formattedForSwiftTypeName }
    }
    
    var objectItemPropertyStrings: [String] {
        return objectItems.map { SwiftLanguage.propertyString(name: $0.key, withType: $0.key.formattedForSwiftTypeName) }
    }
    
    var objectItemInitStrings: [String] {
        return objectItems.map { "let \($0.key)Object = dictionary[\"\($0.key)\"] as? [String : Any] ?? [:]\n\t\tself.\($0.key) = \($0.key.formattedForSwiftTypeName)(with: \($0.key)Object)" }
    }
    
    var objectItemStructNames: [String] {
        return objectItems.map { "\($0.key.formattedForSwiftTypeName)" }
    }
    
    var stringItemPropertyStrings: [String] {
        return stringItems.map { SwiftLanguage.propertyString(name: $0.key, withType: "String") }
    }
    
    var stringItemInitStrings: [String] {
        return stringItems.map { SwiftLanguage.initializerWithDefaultValueCast(name: $0.key, dictionaryName: swiftToOriginalKeyMapping[$0.key]!, toType: "String", defaultValueString: "\"\"") }
    }
    
    var numberItemPropertyStrings: [String] {
        return numberItems.map { SwiftLanguage.propertyString(name: $0.key, withType: "Double") }
    }
    
    var numberItemInitStrings: [String] {
        return numberItems.map { SwiftLanguage.initializerWithDefaultValueCast(name: $0.key, dictionaryName: swiftToOriginalKeyMapping[$0.key]!, toType: "Double", defaultValueString: "0.0") }
    }
    
    var boolItemPropertyStrings: [String] {
        return boolItems.map { SwiftLanguage.propertyString(name: $0.key, withType: "Bool") }
    }
    
    var boolItemInitStrings: [String] {
        return boolItems.map { SwiftLanguage.initializerWithDefaultValueCast(name: $0.key, dictionaryName: swiftToOriginalKeyMapping[$0.key]!, toType: "Bool", defaultValueString: "false") }
    }
    
    var nullItemPropertyStrings: [String] {
        return nullItems.map { SwiftLanguage.propertyString(name: $0.key, withType: "Any?") }
    }
    
    var nullItemInitStrings: [String] {
        return nullItems.map { SwiftLanguage.initializer(name: $0.key, dictionaryName: swiftToOriginalKeyMapping[$0.key]!) }
    }
}
