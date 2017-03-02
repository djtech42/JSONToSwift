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
    case dictionary(name: String)
    case string
    case number
    case bool
    case null
}

extension JSONStringProvider: CustomStringConvertible {
    var description: String {
        switch self {
        case .array: return "[Any]"
        case .dictionary(let name): return "\(name)"
        case .string: return "String"
        case .number: return "Double"
        case .bool: return "Bool"
        case .null: return "Any?"
        }
    }
    
    var defaultValue: String? {
        switch self {
        case .array: return "[]"
        case .dictionary: return ""
        case .string: return "\"\""
        case .number: return "0.0"
        case .bool: return "false"
        case .null: return .none
        }
    }
    
    var nullDefault: String? {
        switch self {
        case .null: return "Any"
        default: return .none
        }
    }
    
    var comment: String {
        let specificString: String
        switch self {
        case .array: specificString = "Array"
        case .dictionary: specificString = "Other"
        case .string: specificString = "String"
        case .number: specificString = "Number"
        case .bool: specificString = "Bool"
        case .null: specificString = "Null"
        }
        return "//    \(specificString) Objects"
    }
    
}
