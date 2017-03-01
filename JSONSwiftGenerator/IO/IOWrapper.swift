//
//  IOWrapper.swift
//  JSONSwiftGenerator
//
//  Created by Brenden Konnagan on 2/28/17.
//  Copyright © 2017 Bren. All rights reserved.
//

import Foundation

struct IOWrapper {
    static func checkArguments() -> DataRouter {
        var enteredArguments = CommandLine.arguments
        //  Remove application argument
        enteredArguments.removeFirst()
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
    
    static func getInputFile() -> DataRouter {
        print("Please enter path to JSON data")
        guard let path = readLine(strippingNewline: true) else {
            return getInputFile()
        }
        return DataRouter.file(location: URL(fileURLWithPath: path))
    }
    
    static func getNameForObject() -> String {
        print("Please enter name for root object")
        return readLine(strippingNewline: true) ?? ""
    }
}
