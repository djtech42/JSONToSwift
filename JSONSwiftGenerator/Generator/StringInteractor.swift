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
    case structName(name: String)
    case extensionName(name: String)
    case newLine
    case close
    case initializer
    case property(string: String)
    case initProperty(string: String)
    case equatableFunctionDeclaration(name: String)
    case equatableFunctionStart
    case equatableComparison(name: String)
    case andOperator
    case comment(string: String)
}

extension StringInteractor: CustomStringConvertible {
    var description: String {
        switch self {
        case .header(let url): return "//\n//    JSON to Swift Generated Model\n//    Code generator created by: Bren Konnagan\n//\n//    Created from: \(string(for: url))\n//    Generated on: \(timeStamp())\n"
        case .structName(let name): return "struct \(name) {"
        case .extensionName(let name): return "extension \(name): Equatable {"
        case .newLine: return "\n"
        case .close: return "}"
        case .initializer: return "init(with dictionary: [String: Any]) {"
        case .property(let string): return string
        case .initProperty(let string): return string
        case .equatableFunctionDeclaration(let name): return "static func ==(lhs: \(name), rhs: \(name)) -> Bool {"
        case .equatableFunctionStart: return "return "
        case .equatableComparison(let name): return "lhs.\(name) == rhs.\(name)"
        case .andOperator: return " && "
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
