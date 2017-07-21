//
//  IOWrapper.swift
//  JSONSwiftGenerator
//
//  Created by Brenden Konnagan on 2/28/17.
//  Copyright © 2017 Bren. All rights reserved.
//

import Foundation

enum Input {
    static var arguments: [String] {
        return Array(CommandLine.arguments.dropFirst())
    }
    static var flags: [Character]? {
        guard let existingHyphenArgument = arguments.first(where: { $0.characters.first == "-" }) else { return nil }
        
        return Array(existingHyphenArgument.characters.dropFirst())
    }
    
    static func getFilePath() -> DataRouter {
        print("Please enter path to JSON data")
        guard let path = readLine(strippingNewline: true), let existingRoute = route(from: [path]) else {
            return getFilePath()
        }
        return existingRoute
    }
    
    static func getNameForObject() -> String {
        print("Please enter name for root object")
        return readLine(strippingNewline: true) ?? ""
    }
    
    static func getUseEquatable() -> Bool {
        print("Generate Equatable extension? (y/n)")
        return readLine(strippingNewline: true)?.lowercased() == "y"
    }
}

extension Input {
    static func route(from arguments: [String]) -> DataRouter? {
        let enteredArguments = arguments
        
        guard enteredArguments.isNotEmpty, let fileArgument = enteredArguments.first(where: { $0.contains(".") }) else { return .none }
        if let url = URL(string: fileArgument) {
            if url.host != nil {
                return .url(location: url)
            }
            else {
                return .file(location: URL(fileURLWithPath: fileArgument))
            }
        }
        return .none
    }
}

enum Output {
    static func printNewline() {
        print()
    }
    
    static func printCastWarning(for keys: [String]) {
        keys.forEach { print("\($0) has a null value, so it was cast to Any? by default") }
    }
    
    static func printThatFileIsWritten(withName name: String) {
        print("file \(name) written successfully")
    }
}
