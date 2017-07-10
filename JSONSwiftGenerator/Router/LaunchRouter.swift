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
        
        let verbose: Bool = RecognizedArguments.recognized(from: Input.flags).contains(.verbose)
        
        let objectName: String
        let recognizedArguments = RecognizedArguments.recognized(from: Input.flags)
        
        if recognizedArguments.contains(.automaticRootName) {
            let filename = location.lastPathComponent
            if !filename.isEmpty {
                objectName = filename.removingOccurrences(of: ".json").formattedForSwiftTypeName
            }
            else {
                if verbose {
                    print("verbose: automatic root object name retrieval failed")
                }
                objectName = Input.getNameForObject()
            }
        }
        else {
            objectName = Input.getNameForObject()
        }
        
        let useEquatable: Bool
        if recognizedArguments.contains(.equatable) {
            useEquatable = true
        }
        else {
            useEquatable = Input.getUseEquatable()
        }
        
        if recognizedArguments.contains(.legacy) {
            SwiftLanguage.globalVersionSetting = .three
        }
        let converter = JSONToSwift(with: location, rootObjectName: objectName, generateEquatable: useEquatable, verbose: verbose)
        try converter.convert()
    }
}
