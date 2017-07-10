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
    
    static var globalVersionSetting: SwiftLanguage.Version = .four
    
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
    
    enum Keyword {
        static let `struct` = "struct"
        static let `extension` = "extension"
        static let `static` = "static"
        static let `func` = "func"
        static let `private` = "private"
        static let `enum` = "enum"
    }
    enum ConformingProtocol {
        static var encodingAndDecoding: String {
            switch SwiftLanguage.globalVersionSetting {
            case .four: return ": Codable"
            default: return ""
            }
        }
        static let equatable = ": Equatable"
    }
}
