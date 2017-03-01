//
//  StringInteractor.swift
//  JSONSwiftGenerator
//
//  Created by Brenden Konnagan on 2/28/17.
//  Copyright © 2017 Bren. All rights reserved.
//

import Foundation

enum StringInteractor {
    case header(remoteURL: URL)
    case structName(string: String)
    case newLine
    case close
    case initializer
    case property(name: String, type: String)
    case initProperty(name: String, provider: JSONStringProvider)
    case comment(string: String)
}

extension StringInteractor: CustomStringConvertible {
    var description: String {
        switch self {
        case .header(let url): return "//\n//    JSON to Swift Generated Model\n//    Code generator created by: Bren Konnagan\n//\n//    Created from: \(string(for: url))\n//    Generated on: \(timeStamp())\n"
        case .structName(let name): return "struct \(name) {"
        case .newLine: return "\n"
        case .close: return "}"
        case .initializer: return "init(with dictionary: [String: Any]) {"
        case .property(let name, let type): return "let \(name): \(type)"
        case .initProperty(let name, let provider): return provider.defaultValue == nil ? "self.\(name) = dictionary[\"\(name)\"] as? \(provider.nullDefault!)" : "self.\(name) = dictionary[\"\(name)\"] as? \(provider.description) ?? \(provider.defaultValue!)"
        case .comment(let string): return string
        }
    }
}

extension StringInteractor {
    fileprivate func string(for url: URL) -> String {
        return url.absoluteString
    }
    
    fileprivate func timeStamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: Date())
    }
}
