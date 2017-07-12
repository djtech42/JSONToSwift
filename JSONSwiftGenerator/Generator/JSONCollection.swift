//
//  JSONCollection.swift
//  JSONSwiftGenerator
//
//  Created by Brenden Konnagan on 2/28/17.
//  Copyright © 2017 Bren. All rights reserved.
//

import Foundation

struct JSONCollection<Element> {
    fileprivate var contents: [String: Element] = [:]
    var originalKeys: [String: Element] = [:]
    var containsBadKey: Bool = false
    
    init(with key: String, element: Element) {
        if !key.isFormattedForSwiftPropertyName {
            containsBadKey = true
        }
        originalKeys[key] = element
        add(element, for: key.formattedForSwiftPropertyName)
    }
    
    init<S: Sequence>(_ sequence: S) where S.Iterator.Element == (key: String, value: Element) {
        for (key, value) in sequence {
            if !key.isFormattedForSwiftPropertyName {
                containsBadKey = true
            }
            originalKeys[key] = value
            add(value, for: key.formattedForSwiftPropertyName)
        }
    }
}

extension JSONCollection {
    mutating func add(_ element: Element, for key: String) {
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
    init(dictionaryLiteral elements: (String, Element)...) {
        self.init(elements.map { (key: $0.0, value: $0.1) })
    }
}

extension JSONCollection: Sequence {
    typealias Iterator = AnyIterator<(value: Element, key: String)>
    
    func makeIterator() -> Iterator {
        var existingIterator = contents.makeIterator()
        return AnyIterator {
            return existingIterator.next()
        }
    }
}

extension JSONCollection: Collection {
    typealias Index = DictionaryIndex<String, Element>
    
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
    
    func index(after i: Index) -> Index {
        return contents.index(after: i)
    }
}

extension JSONCollection {
    var equatableItems: [(key: String, value: Element)]  {
        return contents.filter { $0.value is Dictionary<String, Any> || $0.value is String || $0.value is Double || $0.value is Bool || $0.value is [Bool] || $0.value is [String] || $0.value is [Double] }
    }
    
    var arrayItems: [(key: String, value: Element)] {
        return contents.filter { $0.value is Array<Any> }
    }
    
    var dictionaryArrayItems: [(key: String, value: Element)] {
        return contents.filter { $0.value is [Dictionary<String, Any>] }
    }
    
    var dictionaryItems: [(key: String, value: Element)] {
        return contents.filter { $0.value is Dictionary<String, Any> }
    }
    
    var stringItems: [(key: String, value: Element)] {
        return contents.filter { $0.value is String }
    }
    
    var numberItems: [(key: String, value: Element)] {
        return contents.filter { $0.value is Double }
    }
    
    var boolItems: [(key: String, value: Element)] {
        let mutableCopy = contents.filter({ !($0.value is Double)  })
        return mutableCopy.filter { $0.value is Bool }
    }
    
    var nullItems: [(key: String, value: Element)] {
        return contents.filter { !($0.value is Array<Any>) && !($0.value is Dictionary<String, Any>) && !($0.value is String) && !($0.value is Double) && !($0.value is Bool) }
    }
}

extension JSONCollection {
    var arrayItemPropertyStrings: [String] {
        var allArrayPropertyStrings: [String] = []
        
        allArrayPropertyStrings += arrayItems.filter({ !($0.value is [Double])  }).filter { $0.value is [Bool] }.map { SwiftLanguage.propertyString(name: $0.key, withType: "[Bool]") }
        allArrayPropertyStrings += arrayItems.filter { $0.value is [Double] }.map { SwiftLanguage.propertyString(name: $0.key, withType: "[Double]") }
        allArrayPropertyStrings += arrayItems.filter { $0.value is [String] }.map { SwiftLanguage.propertyString(name: $0.key, withType: "[String]") }
        allArrayPropertyStrings += dictionaryArrayItems.map { SwiftLanguage.propertyString(name: $0.key, withType: "[\(String($0.key.dropLast()).formattedForSwiftTypeName)]") }
        allArrayPropertyStrings += arrayItems.filter { !($0.value is [String]) && !($0.value is [Double]) && !($0.value is [Bool]) && !($0.value is [Dictionary<String, Any>])}.map { SwiftLanguage.propertyString(name: $0.key, withType: "[Any]") }
        
        return allArrayPropertyStrings
    }
    
    var arrayItemInitStrings: [String] {
        var allArrayInitStrings: [String] = []
        
        allArrayInitStrings += arrayItems.filter({ !($0.value is [Double])  }).filter { $0.value is [Bool] }.map { SwiftLanguage.initializerWithDefaultValueCast(name: $0.key, toType: "[Bool]", defaultValueString: "[]") }
        allArrayInitStrings += arrayItems.filter { $0.value is [Double] }.map { SwiftLanguage.initializerWithDefaultValueCast(name: $0.key, toType: "[Double]", defaultValueString: "[]") }
        allArrayInitStrings += arrayItems.filter { $0.value is [String] }.map { SwiftLanguage.initializerWithDefaultValueCast(name: $0.key, toType: "[String]", defaultValueString: "[]")}
        allArrayInitStrings += dictionaryArrayItems.map { SwiftLanguage.initializerWithDefaultValueCast(name: $0.key, toType: "[\(String($0.key.dropLast()).formattedForSwiftTypeName)]", defaultValueString: "[]")}
        allArrayInitStrings += arrayItems.filter { !($0.value is [String]) && !($0.value is [Double]) && !($0.value is [Bool]) && !($0.value is [Dictionary<String, Any>])}.map { SwiftLanguage.initializerWithDefaultValueCast(name: $0.key, toType: "[Any]", defaultValueString: "[]") }
        
        return allArrayInitStrings
    }
    
    var objectArrayItemStructNames: [String] {
        return dictionaryArrayItems.map { array in
            return String(array.key.dropLast()).formattedForSwiftTypeName
        }
    }
    
    var objectItemPropertyStrings: [String] {
        return dictionaryItems.map { SwiftLanguage.propertyString(name: $0.key, withType: $0.key.formattedForSwiftTypeName) }
    }
    
    var objectItemInitStrings: [String] {
        return dictionaryItems.map { "let \($0.key)Object = dictionary[\"\($0.key)\"] as? [String: Any] ?? [:]\n\t\tself.\($0.key) = \($0.key.capitalized)(with: \($0.key)Object)" }
    }
    
    var objectItemStructNames: [String] {
        return dictionaryItems.map { object in
            return "\(object.key.formattedForSwiftTypeName)"
        }
    }
    
    var stringItemPropertyStrings: [String] {
        return stringItems.map { SwiftLanguage.propertyString(name: $0.key, withType: "String") }
    }
    
    var stringItemInitStrings: [String] {
        return stringItems.map { SwiftLanguage.initializerWithDefaultValueCast(name: $0.key, toType: "String", defaultValueString: "\"\"") }
    }
    
    var numberItemPropertyStrings: [String] {
        return numberItems.map { SwiftLanguage.propertyString(name: $0.key, withType: "Double") }
    }
    
    var numberItemInitStrings: [String] {
        return numberItems.map { SwiftLanguage.initializerWithDefaultValueCast(name: $0.key, toType: "Double", defaultValueString: "0.0") }
    }
    
    var boolItemPropertyStrings: [String] {
        return boolItems.map { SwiftLanguage.propertyString(name: $0.key, withType: "Bool") }
    }
    
    var boolItemInitStrings: [String] {
        return boolItems.map { SwiftLanguage.initializerWithDefaultValueCast(name: $0.key, toType: "Bool", defaultValueString: "false") }
    }
    
    var nullItemPropertyStrings: [String] {
        return nullItems.map { SwiftLanguage.propertyString(name: $0.key, withType: "Any?") }
    }
    
    var nullItemInitStrings: [String] {
        return nullItems.map { SwiftLanguage.initializerNonOptionalCast(name: $0.key, toType: "Any") }
    }
}






