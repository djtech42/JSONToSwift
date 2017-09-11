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
        let recognizedArguments = RecognizedArguments.recognized(from: Input.flags)
        let verbose = recognizedArguments.contains(.verbose)
        
        let objectName: String
        
        if recognizedArguments.contains(.automaticRootName) {
            let filename = router.location.lastPathComponent
            if filename.isNotEmpty {
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
        let converter = JSONToSwift(with: router.location, rootObjectName: objectName, generateEquatable: useEquatable, verbose: verbose)
        try converter.convert()
    }
}
