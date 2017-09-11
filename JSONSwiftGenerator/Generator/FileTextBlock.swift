//
//  FileTextBlock.swift
//  JSONSwiftGenerator
//
//  Created by Brenden Konnagan on 2/28/17.
//  Copyright © 2017 Bren. All rights reserved.
//

import Foundation

enum FileTextBlock {
    case header(remoteURL: URL)
    
    case structName(name: String, swiftVersion: SwiftLanguage.Version)
    case extensionName(name: String)
    
    case property(string: String)
    case initializer
    
    case codingKeysEnum
    case codingKeysEnumPropertyCase(name: String)
    
    case encodeFunctionDeclaration
    case encodeFunctionContainerAssign
    case encodeFunctionStatement(propertyName: String)
    
    case equatableFunctionDeclaration(name: String)
    case equatableComparison(name: String)
    case equatableFunctionEnd
    
    case comment(string: String)
    
    case newLine(indentLevel: Int)
    case close
}

extension FileTextBlock: CustomStringConvertible {
    var description: String {
        switch self {
        case .header(let url): return """
            //
            //    JSON to Swift Generated Model
            //    Code generator created by: Bren Konnagan and Dan Turner
            //
            //    Created from: \(string(for: url))
            //    Generated on: \(timeStamp())
            
            """
            
        case .structName(let name, let swiftVersion): return "\(SwiftLanguage.Keyword.struct) \(name)\(SwiftLanguage.ConformingProtocol.encodingAndDecoding(in: swiftVersion)) {"
        case .extensionName(let name): return "\(SwiftLanguage.Keyword.extension) \(name)\(SwiftLanguage.ConformingProtocol.equatable) {"
            
        case .property(let string): return string
        case .initializer: return "init(with dictionary: [String : Any]) {"
        
        case .codingKeysEnum: return "\(SwiftLanguage.Keyword.private) \(SwiftLanguage.Keyword.enum) CodingKeys: String, CodingKey {"
        case .codingKeysEnumPropertyCase(let name): return "case \(name.formattedForSwiftPropertyName) = \"\(name)\""
            
        case .encodeFunctionDeclaration: return "public func encode(to encoder: Encoder) throws {"
        case .encodeFunctionContainerAssign: return "var container = encoder.container(keyedBy: CodingKeys.self)"
        case .encodeFunctionStatement(let name): return "try container.encode(\(name.formattedForSwiftPropertyName), forKey: .\(name.formattedForSwiftPropertyName))"
            
        case .equatableFunctionDeclaration(let name): return "\(SwiftLanguage.Keyword.static) \(SwiftLanguage.Keyword.func) ==(lhs: \(name), rhs: \(name)) -> Bool {"
        case .equatableComparison(let name): return "guard lhs.\(name) == rhs.\(name) else { return false }"
        case .equatableFunctionEnd: return "return true"
            
        case .comment(let string): return string
            
        case .newLine(let indentLevel): return """
        
        \(String(repeating: "\t", count: indentLevel))
        """
        case .close: return "}"
        }
    }
}

extension FileTextBlock {
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
