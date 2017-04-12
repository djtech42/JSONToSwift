//
//  SwiftLanguage.swift
//  JSONSwiftGenerator
//
//  Created by Dan Turner on 3/3/17.
//  Copyright © 2017 Bren. All rights reserved.
//

import Foundation

enum SwiftLanguage {
    static var disallowedPropertyNameCharacters: [Character] = [" ", "$", "-"]
    static var disallowedTypeNameCharacters: [Character] = [" ", "$", "-"]
    
    static func propertyString(name: String, withType type: String) -> String {
        return "let \(name): \(type)"
    }
    static func initializerWithDefaultValueCast(name: String, toType type: String, defaultValueString: String) -> String {
        return "self.\(name) = dictionary[\"\(name)\"] as? \(type) ?? \(defaultValueString)"
    }
    static func initializerNonOptionalCast(name: String, toType type: String) -> String {
        return "self.\(name) = dictionary[\"\(name)\"] as \(type)"
    }
}
