//
//  JSONType.swift
//  JSONSwiftGenerator
//
//  Created by Brenden Konnagan on 2/28/17.
//  Copyright © 2017 Bren. All rights reserved.
//

import Foundation

typealias Object = [String : Any]

enum JSONType: String {
    case array
    case object
    case string
    case number
    case bool
    case null
}

extension JSONType: CustomStringConvertible {
    var description: String {
        return rawValue.capitalized
    }
    
    var comment: String {
        return "//    \(self) Properties"
    }
    
}
