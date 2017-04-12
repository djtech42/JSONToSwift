//
//  LaunchRouter.swift
//  JSONSwiftGenerator
//
//  Created by Brenden Konnagan on 3/1/17.
//  Copyright © 2017 Bren. All rights reserved.
//

import Foundation

enum LaunchRouter {
    static func run() throws {
        let argumentRouter = Input.route(from: Input.arguments)
        guard let providedUrl = argumentRouter else {
            let inputFile = Input.getFilePath()
            try LaunchRouter.execute(with: inputFile)
            return
        }
        
        try LaunchRouter.execute(with: providedUrl)
    }
    
    fileprivate static func execute(with router: DataRouter) throws {
        guard let location = router.location else {
            throw JSONToSwiftError(message: "Invalid URL provided")
        }
        
        let objectName: String
        if RecognizedArguments.recognized(from: Input.flags).contains(.automaticRootName) {
            objectName = location.lastPathComponent.removingOccurrences(of: ".json").formattedForSwiftTypeName
        }
        else {
            objectName = Input.getNameForObject()
        }
        
        let useEquatable: Bool
        if RecognizedArguments.recognized(from: Input.flags).contains(.equatable) {
            useEquatable = true
        }
        else {
            useEquatable = Input.getUseEquatable()
        }
        
        let verbose: Bool = RecognizedArguments.recognized(from: Input.flags).contains(.verbose)
        let converter = JSONToSwift(with: location, rootObjectName: objectName, generateEquatable: useEquatable, verbose: verbose)
        try converter.convert()
    }
}
