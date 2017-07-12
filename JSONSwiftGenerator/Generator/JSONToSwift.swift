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
    let verbose: Bool
    let startTime: CFAbsoluteTime
    
    var elapsedTime: CFAbsoluteTime {
        return CFAbsoluteTimeGetCurrent() - startTime
    }
    
    init(with jsonPath: URL, rootObjectName: String, generateEquatable: Bool, subObject: JSONCollection<Any>? = .none, rootFolderName: String? = .none, verbose: Bool) {
        self.jsonPath = jsonPath
        self.rootObjectName = rootObjectName
        self.generateEquatable = generateEquatable
        self.subObject = subObject
        self.rootFolderName = rootFolderName
        self.verbose = verbose
        
        startTime = CFAbsoluteTimeGetCurrent()
    }
    
    func convert() throws {
        let jsonData = try Data(contentsOf: jsonPath)
        if verbose {
            print("verbose: data read from \(rootObjectName) JSON\t\(elapsedTime)")
        }
        let json = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if verbose {
            print("verbose: data serialized from \(rootObjectName) JSON\t\(elapsedTime)")
        }
        let collection = try JSONInteractor.generateCollection(from: json)
        if verbose {
            print("verbose: \(rootObjectName) serialization converted to Swift collection\t\(elapsedTime)")
        }
        try convert(collection: collection)
    }
    
    fileprivate func convert(collection: JSONCollection<Any>) throws {
        if collection.nullItems.count > 0 {
            Output.printNewline()
            Output.printCastWarning(for: collection.nullItems.map({ $0.key }))
        }
        
        let structString = string(from: collection)
        if verbose {
            print("verbose: Swift collection for \(rootObjectName) converted to a string")
        }
        try writeToSwiftFile(string: structString)
        
        try createSubObjects(from: collection)
        
        Output.printNewline()
        Output.printThatFileIsWritten(withName: rootObjectName)
        if verbose {
            Output.printNewline()
        }
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
        var strings: [FileTextBlock] = [.header(remoteURL: jsonPath), .newLine(indentLevel: 0), .structName(name: rootObjectName)]
        addPropertyStrings(in: &strings, from: collection)
        if SwiftLanguage.globalVersionSetting == .three {
            strings.append(.newLine(indentLevel: 1))
            strings.append(.initializer)
            addInitializerDelclarations(in: &strings, from: collection)
            strings.append(contentsOf: [.newLine(indentLevel: 1), .close])
        }
        if SwiftLanguage.globalVersionSetting == .four && collection.containsBadKey {
            strings.append(contentsOf: [.newLine(indentLevel: 1), .codingKeysEnum])
            for (badKey, _) in collection.originalKeys {
                strings.append(contentsOf: [.newLine(indentLevel: 2), .codingKeysEnumPropertyCase(name: badKey)])
            }
            strings.append(contentsOf: [.newLine(indentLevel: 1), .close, .newLine(indentLevel: 1), .newLine(indentLevel: 1), .encodeFunctionDeclaration, .newLine(indentLevel: 2), .encodeFunctionContainerAssign, .newLine(indentLevel: 2)])
            for (badKey, _) in collection.originalKeys {
                strings.append(contentsOf: [.newLine(indentLevel: 2), .encodeFunctionStatement(propertyName: badKey)])
            }
            strings.append(contentsOf: [.newLine(indentLevel: 1), .close])
        }
        strings.append(contentsOf: [.newLine(indentLevel: 0), .close])
        if generateEquatable {
            strings.append(contentsOf: [.newLine(indentLevel: 0), .newLine(indentLevel: 0), .extensionName(name: rootObjectName), .newLine(indentLevel: 1), .equatableFunctionDeclaration(name: rootObjectName), .newLine(indentLevel: 2), .equatableFunctionStart])
            collection.equatableItems.map({ $0.key }).enumerated().forEach { let (index, key) = $0;
            strings.append(.equatableComparison(name: key))
            if index < collection.equatableItems.count - 1 {
                strings.append(.andOperator)
                strings.append(.newLine(indentLevel: 3))
                }
            }
            strings.append(contentsOf: [.newLine(indentLevel: 1), .close, .newLine(indentLevel: 0), .close])
        }
        return strings.reduce("", { (string, interactor) -> String in
            return string + interactor.description
        })
    }
    
    fileprivate func addPropertyStrings(in strings: inout [FileTextBlock], from collection: JSONCollection<Any>) {
        if collection.arrayItems.count > 0 {
            strings.append(.newLine(indentLevel: 1))
            strings.append(.comment(string: JSONType.array.comment))
            collection.arrayItemPropertyStrings.forEach({ appendProperty(string: $0, stringsCollection: &strings) })
            strings.append(.newLine(indentLevel: 1))
        }
        if collection.dictionaryItems.count > 0 {
            strings.append(.newLine(indentLevel: 1))
            strings.append(.comment(string: JSONType.dictionary.comment))
            collection.objectItemPropertyStrings.forEach({ appendProperty(string: $0, stringsCollection: &strings) })
            strings.append(.newLine(indentLevel: 1))
        }
        if collection.stringItems.count > 0 {
            strings.append(.newLine(indentLevel: 1))
            strings.append(.comment(string: JSONType.string.comment))
            collection.stringItemPropertyStrings.forEach({ appendProperty(string: $0, stringsCollection: &strings) })
            strings.append(.newLine(indentLevel: 1))
        }
        if collection.numberItems.count > 0 {
            strings.append(.newLine(indentLevel: 1))
            strings.append(.comment(string: JSONType.number.comment))
            collection.numberItemPropertyStrings.forEach({ appendProperty(string: $0, stringsCollection: &strings) })
            strings.append(.newLine(indentLevel: 1))
        }
        if collection.boolItems.count > 0 {
            strings.append(.newLine(indentLevel: 1))
            strings.append(.comment(string: JSONType.bool.comment))
            collection.boolItemPropertyStrings.forEach({ appendProperty(string: $0, stringsCollection: &strings) })
            strings.append(.newLine(indentLevel: 1))
        }
        if collection.nullItems.count > 0 {
            strings.append(.newLine(indentLevel: 1))
            strings.append(.comment(string: JSONType.null.comment))
            collection.nullItemPropertyStrings.forEach({ appendProperty(string: $0, stringsCollection: &strings) })
            strings.append(.newLine(indentLevel: 1))
        }
    }
    
    fileprivate func appendProperty(string: String, stringsCollection: inout [FileTextBlock]) {
        stringsCollection.append(.newLine(indentLevel: 1))
        stringsCollection.append(.property(string: string))
    }
    
    fileprivate func appendPropertyAssignment(string: String, stringsCollection: inout [FileTextBlock]) {
        stringsCollection.append(.newLine(indentLevel: 2))
        stringsCollection.append(.property(string: string))
    }
    
    fileprivate func addInitializerDelclarations(in strings: inout [FileTextBlock], from collection: JSONCollection<Any>) {
        collection.arrayItemInitStrings.forEach({ appendPropertyAssignment(string: $0, stringsCollection: &strings) })
        collection.objectItemInitStrings.forEach({ appendPropertyAssignment(string: $0, stringsCollection: &strings) })
        collection.stringItemInitStrings.forEach({ appendPropertyAssignment(string: $0, stringsCollection: &strings) })
        collection.numberItemInitStrings.forEach({ appendPropertyAssignment(string: $0, stringsCollection: &strings) })
        collection.boolItemInitStrings.forEach({ appendPropertyAssignment(string: $0, stringsCollection: &strings) })
        collection.nullItemInitStrings.forEach({ appendPropertyAssignment(string: $0, stringsCollection: &strings) })
    }
}

extension JSONToSwift {
    fileprivate func createSubObjects(from collection: JSONCollection<Any>) throws {
        var jsonToSwiftGenerators: [JSONToSwift] = []
        collection.objectItemStructNames.enumerated().forEach { let (index, name) = $0;
            let dictionary = collection.dictionaryItems[index].value as? [String: Any] ?? [:]
            let newCollection = JSONCollection(dictionary)
            let nameForDirectory = collection.objectItemStructNames.count > 1 ? rootObjectName : rootFolderName
            let generator = JSONToSwift(with: jsonPath, rootObjectName: name, generateEquatable: generateEquatable, subObject: newCollection, rootFolderName: nameForDirectory, verbose: verbose)
            jsonToSwiftGenerators.append(generator)
        }
        collection.objectArrayItemStructNames.enumerated().forEach { let (index, name) = $0;
            let dictionaryArray = collection.dictionaryArrayItems[index].value as? [[String: Any]] ?? [[:]]
            guard let existingDictionary = dictionaryArray.first else { return }
            
            let newCollection = JSONCollection(existingDictionary)
            let nameForDirectory = collection.objectArrayItemStructNames.count > 1 ? rootObjectName : rootFolderName
            let generator = JSONToSwift(with: jsonPath, rootObjectName: name, generateEquatable: generateEquatable, subObject: newCollection, rootFolderName: nameForDirectory, verbose: verbose)
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
