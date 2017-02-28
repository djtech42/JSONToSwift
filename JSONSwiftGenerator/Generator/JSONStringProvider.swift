//
//  JSONStringProvider.swift
//  JSONSwiftGenerator
//
//  Created by Brenden Konnagan on 2/28/17.
//  Copyright © 2017 Bren. All rights reserved.
//

import Foundation

enum JSONStringProvider {
    case array
    case dictionary
    case string
    case number
    case bool
    case null
}

extension JSONStringProvider: CustomStringConvertible {
    var description: String {
        switch self {
        case .array: return "[Any]"
        case .dictionary: return "[String: Any]"
        case .string: return "String"
        case .number: return "Double"
        case .bool: return "Bool"
        case .null: return "Any?"
        }
    }
    
    var defaultValue: String {
        switch self {
        case .array: return "[]"
        case .dictionary: return "[:]"
        case .string: return "\"\""
        case .number: return "0.0"
        case .bool: return "false"
        case .null: return "Any"
        }
    }
    
    var comment: String {
        switch self {
        case .array: return "//    Array Objects"
        case .dictionary: return "//    Dictionary Objects"
        case .string: return "//    String Objects"
        case .number: return "//    Number Objects"
        case .bool: return "//    Bool Objects"
        case .null: return "//    Null Objects"
        }
    }
}
