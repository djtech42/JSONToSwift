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
        let argumentRouter = Input.route(from: Input.flags)
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
        let objectName = Input.getNameForObject()
        let useEquatable: Bool
        if RecognizedArguments.recognized(from: Input.flags).contains(.equatable) {
            useEquatable = true
        }
        else {
            useEquatable = Input.getUseEquatable()
        }
        let converter = JSONToSwift(with: location, rootObjectName: objectName, generateEquatable: useEquatable)
        try converter.convert()
    }
}
