//
//  JSONToSwift.swift
//  JSONSwiftGenerator
//
//  Created by Brenden Konnagan on 2/28/17.
//  Copyright © 2017 Bren. All rights reserved.
//

import Foundation

struct JSONToSwift {
    fileprivate let jsonPath: URL
    fileprivate let rootObjectName: String
    
    init(with jsonPath: URL, rootObjectName: String) {
        self.jsonPath = jsonPath
        self.rootObjectName = rootObjectName
    }
    
    func convert() throws {
        let jsonData = try Data(contentsOf: jsonPath)
        let json = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        let collection = try JSONInteractor.generateCollection(from: json)
        
        if collection.nullItems.count > 0 {
            Output.printNewline()
            Output.printCastWarning(for: collection.nullItems.map({ $0.key }))
        }
        
        let structString = string(from: collection)
        try writeToSwiftFile(string: structString)
        
        Output.printNewline()
        Output.printThatFileIsWritten()
    }
}

extension JSONToSwift {
    fileprivate func data(at path: String) throws -> Data {
        let url = URL(fileURLWithPath: path)
        return try Data(contentsOf: url)
    }
}

extension JSONToSwift {
    fileprivate func string(from collection: JSONCollection<Any>) -> String {
        var strings: [StringInteractor] = [.header(remoteURL: jsonPath), .newLine, .structName(name: rootObjectName)]
        strings.append(.newLine)
        addPropertyStrings(in: &strings, from: collection)
        strings.append(.newLine)
        strings.append(.initializer)
        strings.append(.newLine)
        addInitializerDelclarations(in: &strings, from: collection)
        strings.append(contentsOf: [.close, .newLine, .close, .newLine])
        strings.append(contentsOf: [.newLine, .extensionName(name: rootObjectName), .newLine, .equatableFunctionDeclaration(name: rootObjectName), .newLine, .equatableFunctionStart])
        for (index, key) in collection.nonNullItems.map({ $0.key }).enumerated() {
            strings.append(.equatableComparison(name: key))
            if index < collection.nonNullItems.count - 1 {
                strings.append(.andOperator)
                strings.append(.newLine)
            }
        }
        strings.append(contentsOf: [.newLine, .close, .newLine, .close])
        return strings.reduce("", { (string, interactor) -> String in
            return string + interactor.description
        })
    }
    
    fileprivate func addPropertyStrings(in strings: inout [StringInteractor], from collection: JSONCollection<Any>) {
        if collection.arrayItems.count > 0 {
            strings.append(.newLine)
            strings.append(.comment(string: JSONStringProvider.array.comment))
            strings.append(.newLine)
            collection.arrayItemPropertyStrings.forEach({ appendProperty(string: $0, stringsCollection: &strings) })
        }
//        if collection.dictionaryItems.count > 0 {
//            strings.append(.newLine)
//            strings.append(.comment(string: JSONStringProvider.dictionary.comment))
//            strings.append(.newLine)
////            for dictionary in collection.dictionaryItems {
////                strings.append(.property(name: dictionary.key, type: JSONStringProvider.dictionary.description))
////                strings.append(.newLine)
////            }
//        }
        if collection.stringItems.count > 0 {
            strings.append(.newLine)
            strings.append(.comment(string: JSONStringProvider.string.comment))
            strings.append(.newLine)
            collection.stringItemPropertyStrings.forEach({ appendProperty(string: $0, stringsCollection: &strings) })
        }
        if collection.numberItems.count > 0 {
            strings.append(.newLine)
            strings.append(.comment(string: JSONStringProvider.number.comment))
            strings.append(.newLine)
            collection.numberItemPropertyStrings.forEach({ appendProperty(string: $0, stringsCollection: &strings) })
        }
        if collection.boolItems.count > 0 {
            strings.append(.newLine)
            strings.append(.comment(string: JSONStringProvider.bool.comment))
            strings.append(.newLine)
            collection.boolItemPropertyStrings.forEach({ appendProperty(string: $0, stringsCollection: &strings) })
        }
        if collection.nullItems.count > 0 {
            strings.append(.newLine)
            strings.append(.comment(string: JSONStringProvider.null.comment))
            strings.append(.newLine)
            collection.nullItemPropertyStrings.forEach({ appendProperty(string: $0, stringsCollection: &strings) })
        }
    }
    
    fileprivate func appendProperty(string: String, stringsCollection: inout [StringInteractor]) {
        stringsCollection.append(.property(string: string))
        stringsCollection.append(.newLine)
    }
    
    fileprivate func addInitializerDelclarations(in strings: inout [StringInteractor], from collection: JSONCollection<Any>) {
        for array in collection.arrayItems {
            strings.append(.initProperty(name: array.key, provider: JSONStringProvider.array))
            strings.append(.newLine)
        }
        for dictionary in collection.dictionaryItems {
            strings.append(.initProperty(name: dictionary.key, provider: JSONStringProvider.dictionary(name: dictionary.key)))
            strings.append(.newLine)
        }
        for string in collection.stringItems {
            strings.append(.initProperty(name: string.key, provider: JSONStringProvider.string))
            strings.append(.newLine)
        }
        for number in collection.numberItems {
            strings.append(.initProperty(name: number.key, provider: JSONStringProvider.number))
            strings.append(.newLine)
        }
        for bool in collection.boolItems {
            strings.append(.initProperty(name: bool.key, provider: JSONStringProvider.bool))
            strings.append(.newLine)
        }
        for null in collection.nullItems {
            strings.append(.initProperty(name: null.key, provider: JSONStringProvider.null))
            strings.append(.newLine)
        }
    }
}

extension JSONToSwift {
    fileprivate func writeToSwiftFile(string: String) throws {
        guard let desktopPath = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first else { return }
        let filePath = desktopPath.appendingPathComponent("\(rootObjectName).swift")
        try string.write(to: filePath, atomically: true, encoding: .utf8)
    }
}
