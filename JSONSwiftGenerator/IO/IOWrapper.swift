//
//  IOWrapper.swift
//  JSONSwiftGenerator
//
//  Created by Brenden Konnagan on 2/28/17.
//  Copyright © 2017 Bren. All rights reserved.
//

import Foundation

struct Input {
    static func checkArguments() -> DataRouter? {
        var enteredArguments = CommandLine.arguments
        //  Remove application argument
        enteredArguments.removeFirst()
        return route(from: enteredArguments)
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
}

extension Input {
    fileprivate static func route(from arguments: [String]) -> DataRouter? {
        var enteredArguments = arguments
        
        guard enteredArguments.count > 0 else { return .none }
        let firstArgument = enteredArguments.removeFirst()
        guard let recognizedArgument = RecognizedArguments.recognized(from: firstArgument) else {
            if let url = URL(string: firstArgument) {
                if url.host != nil { return .url(location: url) }
                else { return .file(location: URL(fileURLWithPath: firstArgument)) }
            }
            return .none
        }
        if recognizedArgument == .url {
            guard enteredArguments.count > 0 else { return .none }
            let path = enteredArguments.removeFirst()
            guard let url = URL(string: path) else { return .none }
            return DataRouter.url(location: url)
        }
        return .none
    }
}

struct Output {
    static func printNewline() {
        print()
    }
    
    static func printCastWarning(for keys: [String]) {
        for key in keys {
            print("\(key) has a null value, so it was casted to Any? by default")
        }
    }
    
    static func printThatFileIsWritten() {
        print("file written successfully")
    }
}
