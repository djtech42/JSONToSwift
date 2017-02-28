//
//  StringInteractor.swift
//  JSONSwiftGenerator
//
//  Created by Brenden Konnagan on 2/28/17.
//  Copyright © 2017 Bren. All rights reserved.
//

import Foundation

enum StringInteractor {
    case header
    case structName(string: String)
    case newLine
    case close
    case initializer
    case property(name: String, type: String)
    case initProperty(name: String, type: String, defaultValue: String)
    case comment(string: String)
}

extension StringInteractor: CustomStringConvertible {
    var description: String {
        switch self {
        case .header: return "//\n//\n//    JSON to Swift Generated Model\n//\n//    Created by: Bren Konnagan\n//\n"
        case .structName(let name): return "struct \(name) {"
        case .newLine: return "\n"
        case .close: return "}"
        case .initializer: return "init(with dictionary: [String: Any]) {"
        case .property(let name, let type): return "let \(name): \(type)"
        case .initProperty(let name, let type, let defaultValue): return "self.\(name) = dictionary[\"\(name)\"] as? \(type) ?? \(defaultValue)"
        case .comment(let string): return string
        }
    }
}
