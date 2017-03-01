//
//  LaunchRouter.swift
//  JSONSwiftGenerator
//
//  Created by Brenden Konnagan on 3/1/17.
//  Copyright © 2017 Bren. All rights reserved.
//

import Foundation

struct LaunchRouter {
    static func run() throws {
        let argumentRouter = IOWrapper.checkArguments()
        guard argumentRouter != .none else {
            let inputFile = IOWrapper.getInputFile()
            try LaunchRouter.execute(with: inputFile)
            return
        }
        guard let providedUrl = argumentRouter else { throw JSONToSwiftError(message: "No file path or URL provided") }
        try LaunchRouter.execute(with: providedUrl)
    }
    
    fileprivate static func execute(with router: DataRouter) throws {
        guard let location = router.location else {
            throw JSONToSwiftError(message: "Invalid URL provided")
        }
        let objectName = IOWrapper.getNameForObject()
        let converter = JSONToSwift(with: location, rootObjectName: objectName)
        try converter.convert()
    }
}
