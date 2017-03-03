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
    let rootFolderName:  String?
    fileprivate let generateEquatable: Bool
    let subObject: JSONCollection<Any>?
    
    init(with jsonPath: URL, rootObjectName: String, generateEquatable: Bool, subObject: JSONCollection<Any>? = .none, rootFolderName: String? = .none) {
        self.jsonPath = jsonPath
        self.rootObjectName = rootObjectName
        self.generateEquatable = generateEquatable
        self.subObject = subObject
        self.rootFolderName = rootFolderName
    }
    
    func convert() throws {
        let jsonData = try Data(contentsOf: jsonPath)
        let json = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        let collection = try JSONInteractor.generateCollection(from: json)
        try convert(collection: collection)
    }
    
    fileprivate func convert(collection: JSONCollection<Any>) throws {
        if collection.nullItems.count > 0 {
            Output.printNewline()
            Output.printCastWarning(for: collection.nullItems.map({ $0.key }))
        }
        
        let structString = string(from: collection)
        try writeToSwiftFile(string: structString)
        
        try createSubObjects(from: collection)
        
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
        strings.append(contentsOf: [.close, .newLine, .close])
        if generateEquatable {
            strings.append(contentsOf: [.newLine, .newLine, .extensionName(name: rootObjectName), .newLine, .equatableFunctionDeclaration(name: rootObjectName), .newLine, .equatableFunctionStart])
            for (index, key) in collection.equatableItems.map({ $0.key }).enumerated() {
                strings.append(.equatableComparison(name: key))
                if index < collection.equatableItems.count - 1 {
                    strings.append(.andOperator)
                    strings.append(.newLine)
                }
            }
            strings.append(contentsOf: [.newLine, .close, .newLine, .close])
        }
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
        if collection.dictionaryItems.count > 0 {
            strings.append(.newLine)
            strings.append(.comment(string: JSONStringProvider.dictionary.comment))
            strings.append(.newLine)
            collection.objectItemPropertyStrings.forEach({ appendProperty(string: $0, stringsCollection: &strings) })
        }
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
        collection.arrayItemInitStrings.forEach({ appendProperty(string: $0, stringsCollection: &strings) })
        collection.objectItemInitStrings.forEach({ appendProperty(string: $0, stringsCollection: &strings) })
        collection.stringItemInitStrings.forEach({ appendProperty(string: $0, stringsCollection: &strings) })
        collection.numberItemInitStrings.forEach({ appendProperty(string: $0, stringsCollection: &strings) })
        collection.boolItemInitStrings.forEach({ appendProperty(string: $0, stringsCollection: &strings) })
        collection.nullItemInitStrings.forEach({ appendProperty(string: $0, stringsCollection: &strings) })
    }
}

extension JSONToSwift {
    fileprivate func createSubObjects(from collection: JSONCollection<Any>) throws {
        var jsonToSwiftGenerators: [JSONToSwift] = []
        for (index, name) in collection.objectItemStructNames.enumerated() {
            let dictionary = collection.dictionaryItems[index].value as? [String: Any] ?? [:]
            let newCollection = JSONCollection(dictionary)
            let nameForDirectory = collection.objectItemStructNames.count > 1 ? rootObjectName : rootFolderName
            let generator = JSONToSwift(with: jsonPath, rootObjectName: name, generateEquatable: generateEquatable, subObject: newCollection, rootFolderName: nameForDirectory)
            jsonToSwiftGenerators.append(generator)
        }
        try jsonToSwiftGenerators.forEach({ try $0.convert(collection: $0.subObject!) })
    }
}

extension JSONToSwift {
    fileprivate func writeToSwiftFile(string: String) throws {
        guard let desktopPath = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first else { return }
        var folderName: String?
        if let createFolderWithName = rootFolderName {
            folderName = createFolderWithName + " Sub Objects"
            let newURL = desktopPath.appendingPathComponent(folderName!, isDirectory: true)
            try! FileManager.default.createDirectory(at: newURL, withIntermediateDirectories: true, attributes: nil)
        }
        let fileWithSubdirectory = folderName != nil ? "\(folderName!)/\(rootObjectName).swift" : "\(rootObjectName).swift"
        let filePath = desktopPath.appendingPathComponent(fileWithSubdirectory)
        try string.write(to: filePath, atomically: true, encoding: .utf8)
    }
}
