//
//  JSONType.swift
//  JSONSwiftGenerator
//
//  Created by Brenden Konnagan on 2/28/17.
//  Copyright © 2017 Bren. All rights reserved.
//

import Foundation

enum JSONType {
    case array
    case dictionary
    case string
    case number
    case bool
    case null
}

extension JSONType {
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
