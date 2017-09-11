//
//  SwiftLanguage.swift
//  JSONSwiftGenerator
//
//  Created by Dan Turner on 3/3/17.
//  Copyright © 2017 Bren. All rights reserved.
//

import Foundation

enum SwiftLanguage {
    enum Version: Int {
        case three = 3
        case four = 4
    }
    
    static var disallowedPropertyNameCharacters: Set<Character> = [" ", "$", "-"]
    static var disallowedTypeNameCharacters: Set<Character> = [" ", "$", "-"]
    
    static func propertyString(name: String, withType type: String, optional: Bool) -> String {
        return "let \(name): \(type)\(optional ? "?" : "")"
    }
    static func initializer(name: String, dictionaryName: String) -> String {
        return "self.\(name) = dictionary[\"\(dictionaryName)\"]"
    }
    static func initializerNonOptionalCast(name: String, dictionaryName: String, toType type: String) -> String {
        return "\(initializer(name: name, dictionaryName: dictionaryName)) as \(type)"
    }
    static func initializerOptionalCast(name: String, dictionaryName: String, toType type: String) -> String {
        return "\(initializer(name: name, dictionaryName: dictionaryName)) as? \(type)"
    }
    static func initializerWithDefaultValueCast(name: String, dictionaryName: String, toType type: String, defaultValueString: String) -> String {
        return "\(initializerOptionalCast(name: name, dictionaryName: dictionaryName, toType: type)) ?? \(defaultValueString)"
    }
    
    enum Keyword {
        static let `struct` = "struct"
        static let `extension` = "extension"
        static let `static` = "static"
        static let `func` = "func"
        static let `private` = "private"
        static let `enum` = "enum"
    }
    enum ConformingProtocol {
        static func encodingAndDecoding(in version: SwiftLanguage.Version) -> String {
            switch version {
            case .four: return ": Codable"
            default: return ""
            }
        }
        static let equatable = ": Equatable"
    }
}
