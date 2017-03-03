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
    
    init(with key: String, element: Element) {
        add(element, for: key.formattedForSwiftPropertyName)
    }
    
    init<S: Sequence>(_ sequence: S) where S.Iterator.Element == (key: String, value: Element) {
        for (key, value) in sequence {
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
        return contents.filter { $0.value is Dictionary<String, Any> || $0.value is String || $0.value is Double || $0.value is Bool }
    }
    
    var arrayItems: [(key: String, value: Element)] {
        return contents.filter { $0.value is Array<Any> }
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
        return arrayItems.map { "let \($0.key): [Any]" }
    }
    
    var arrayItemInitStrings: [String] {
        return arrayItems.map { "self.\($0.key) = dictionary[\"\($0.key)\"] as? [Any] ?? []" }
    }
    
    var objectItemPropertyStrings: [String] {
        return dictionaryItems.map { "let \($0.key): \($0.key.formattedForSwiftTypeName)JSON" }
    }
    
    var objectItemInitStrings: [String] {
        return dictionaryItems.map { "let \($0.key)Object = dictionary[\"\($0.key)\"] as? [String: Any] ?? [:]\nself.\($0.key) = \($0.key.formattedForSwiftTypeName)JSON(with: \($0.key)Object)" }
    }
    
    var objectItemStructNames: [String] {
        return dictionaryItems.map { object in
            return "\(object.key.formattedForSwiftTypeName)JSON"
        }
    }
    
    var stringItemPropertyStrings: [String] {
        return stringItems.map { "let \($0.key): String" }
    }
    
    var stringItemInitStrings: [String] {
        return stringItems.map { "self.\($0.key) = dictionary[\"\($0.key)\"] as? String ?? \"\"" }
    }
    
    var numberItemPropertyStrings: [String] {
        return numberItems.map { "let \($0.key): Double" }
    }
    
    var numberItemInitStrings: [String] {
        return numberItems.map { "self.\($0.key) = dictionary[\"\($0.key)\"] as? Double ?? 0.0" }
    }
    
    var boolItemPropertyStrings: [String] {
        let mutableCopy: [String] = boolItems.filter({ !($0.value is Double)  }).map { $0.key }
        return mutableCopy.map { "let \($0): Bool" }
    }
    
    var boolItemInitStrings: [String] {
        let mutableCopy: [String] = boolItems.filter({ !($0.value is Double)  }).map { $0.key }
        return mutableCopy.map { "self.\($0) = dictionary[\"\($0)\"] as? Bool ?? false" }
    }
    
    var nullItemPropertyStrings: [String] {
        return nullItems.map { "let \($0.key): Any?" }
    }
    
    var nullItemInitStrings: [String] {
        return nullItems.map { "self.\($0.key) = dictionary[\"\($0.key)\"] as Any" }
    }
}






